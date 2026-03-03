#!/bin/bash
# README 업데이트 검토 - PreToolUse Hook (Bash: git push)
# push 전 코드 변경에 대응하는 README 업데이트 여부를 Claude에게 확인 요청
#
# Hook trigger: PreToolUse, matcher: Bash
# Exit codes: 0 = 허용, 2 = 차단 (README 검토 필요)
#
# 통과 조건:
#   - git push가 아닌 명령
#   - SKIP_README_CHECK=1 접두사
#   - push 범위에 변경 파일 없음
#   - README.md가 이미 변경에 포함
#   - 의미 있는 코드 변경 없음 (테스트/설정/lock만 변경)
#   - 대응하는 README.md가 존재하지 않음

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | python3 -c '
import sys, json
data = json.load(sys.stdin)
print(data.get("tool_input", {}).get("command", ""))
' 2>/dev/null)

# git push가 아니면 통과
if ! echo "$COMMAND" | grep -qE '^\s*(SKIP_README_CHECK=\S+\s+)?git\s+push\b'; then
	exit 0
fi

# SKIP_README_CHECK=1 이면 통과
if echo "$COMMAND" | grep -qE 'SKIP_README_CHECK=1'; then
	exit 0
fi

# repo 확인
repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

# push 범위 계산
current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
remote_ref="origin/$current_branch"

# remote에 브랜치가 없으면 main/master 기준
if ! git rev-parse "$remote_ref" &>/dev/null; then
	base_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@') || true
	if [ -z "$base_branch" ]; then
		base_branch=$(git branch -r | grep -E 'origin/(main|master)' | head -1 | sed 's@.*origin/@@' | tr -d ' ') || true
	fi
	[ -z "$base_branch" ] && exit 0
	remote_ref="origin/$base_branch"
fi

range="${remote_ref}..HEAD"

# 변경 파일 목록
changed_files=$(git diff --name-only "$range" 2>/dev/null) || exit 0
[ -z "$changed_files" ] && exit 0

# README가 이미 변경에 포함되어 있으면 통과
if echo "$changed_files" | grep -qE '(^|/)README\.md$'; then
	exit 0
fi

# 의미 있는 코드 변경만 필터 (테스트, 설정, lock, 문서 등 제외)
code_changes=$(echo "$changed_files" | grep -vE '\.(lock|test\.[^.]+|spec\.[^.]+|md|txt|yml|yaml|toml|cfg|ini|env.*)$' | grep -vE '(lock\.json|lockfile)$')
[ -z "$code_changes" ] && exit 0

# 변경 파일에서 가장 가까운 README 탐색
_find_nearest_readme() {
	local dir
	dir=$(dirname "$1")
	while true; do
		if [ -f "$repo_root/$dir/README.md" ]; then
			echo "$dir/README.md"
			return
		fi
		[ "$dir" = "." ] && break
		dir=$(dirname "$dir")
	done
}

readme_list=$(
	echo "$code_changes" | while IFS= read -r file; do
		_find_nearest_readme "$file"
	done | sort -u
)

[ -z "$readme_list" ] && exit 0

# 차단: Claude에게 README 검토 요청
echo "push 전 README.md 업데이트 검토가 필요합니다."
echo ""
echo "=== 변경된 코드 파일 ==="
echo "$code_changes" | head -20
total=$(echo "$code_changes" | wc -l | tr -d ' ')
[ "$total" -gt 20 ] && echo "  ... 외 $((total - 20))개"
echo ""
echo "=== 관련 README ==="
echo "$readme_list"
echo ""
echo "위 README 파일들을 읽고 변경된 코드와 비교하여 업데이트가 필요한지 검토해주세요."
echo "- 업데이트 필요 시: README 수정 → 커밋 → 다시 push"
echo "- 불필요 시: SKIP_README_CHECK=1 git push ..."
exit 2
