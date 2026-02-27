#!/bin/bash
# README.md 검토: 변경된 파일 기준 가장 가까운 README.md를 찾아 업데이트 판단/수정
# 인자: $1=diff_file, $2=log_file, $3=range, $4=mode(--check-only|--update)
set -uo pipefail

diff_file="$1"
log_file="$2"
range="$3"
mode="${4:---check-only}"

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
	echo "  ⚠️  git repo가 아닙니다. 건너뜁니다."
	exit 0
}

# 변경된 파일의 디렉토리에서 repo root까지 올라가며 가장 가까운 README.md 탐색
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

# 변경 파일 목록 → 가장 가까운 README.md 목록 (중복 제거)
readme_list=$(
	git diff --name-only "$range" 2>/dev/null | while IFS= read -r file; do
		_find_nearest_readme "$file"
	done | sort -u
)

if [ -z "$readme_list" ]; then
	echo "  README.md를 찾을 수 없습니다. 건너뜁니다."
	exit 0
fi

commit_log=$(cat "$log_file")

# diff 준비 (너무 크면 stat 요약)
diff_lines=$(wc -l <"$diff_file")
if [ "$diff_lines" -gt 2000 ]; then
	diff_for_review=$(git diff --stat "$range" 2>/dev/null || head -100 "$diff_file")
else
	diff_for_review=$(cat "$diff_file")
fi

needs_update=false

while IFS= read -r readme_rel; do
	readme_path="$repo_root/$readme_rel"
	readme_content=$(cat "$readme_path")

	# --check-only: 업데이트 필요 여부만 판단
	if [ "$mode" = "--check-only" ]; then
		check_result=$(claude -p --output-format text "아래 코드 변경점을 보고 ${readme_rel} 업데이트가 필요한지 판단해주세요.

## 판단 기준
README 업데이트가 필요한 경우:
- 새로운 기능/API가 추가되었지만 README에 문서화되지 않음
- 기존 사용법/설치 방법이 변경됨
- 설정 옵션이 추가/변경/삭제됨
- 의존성 요구사항이 변경됨

README 업데이트가 불필요한 경우:
- 내부 리팩토링, 버그 수정
- 테스트 추가/수정
- 코드 스타일 변경
- README에 문서화되지 않는 내부 구현 변경
- 에러 처리/로깅 변경 등 사용자에게 보이지 않는 내부 동작 변경

## 중요
- 확실히 업데이트가 필요한 경우만 NEEDS_UPDATE로 판단
- 애매하면 NO_UPDATE로 판단 (보수적으로)

## 출력 형식
첫 줄에 반드시: 'NEEDS_UPDATE' 또는 'NO_UPDATE'
NEEDS_UPDATE인 경우 다음 줄부터 업데이트가 필요한 이유를 간결하게 설명

## Commits
${commit_log}

## Diff
${diff_for_review}

## 현재 ${readme_rel}
${readme_content}" 2>/dev/null) || true

		if [ -z "$check_result" ]; then
			echo "  ⚠️  ${readme_rel} 검토를 수행할 수 없습니다. 건너뜁니다."
			continue
		fi

		if echo "$check_result" | grep -q "NEEDS_UPDATE"; then
			echo "  📝 ${readme_rel} 업데이트가 필요합니다:"
			echo "$check_result" | grep -v "NEEDS_UPDATE"
			needs_update=true
		else
			echo "  ✅ ${readme_rel} 업데이트 불필요"
		fi
	fi

	# --update: 실제 README.md 수정 수행
	if [ "$mode" = "--update" ]; then
		echo "  ${readme_rel} 수정 중..."
		claude -p --allowedTools "Read Edit" "아래 코드 변경점을 반영하여 ${readme_path} 파일을 Edit 도구로 직접 수정해주세요.

## 규칙
- 기존 README의 구조와 스타일을 유지
- 변경된 부분만 최소한으로 수정
- 반드시 Edit 도구를 사용하여 파일을 직접 수정

## Commits
${commit_log}

## Diff
${diff_for_review}" >/dev/null 2>&1 || true

		# 실제 변경이 있을 때만 stage
		if git diff --quiet "$readme_path" 2>/dev/null; then
			echo "  ✅ ${readme_rel}에 실제 변경 사항이 없습니다."
			continue
		fi

		git add "$readme_path"
		needs_update=true
		echo "  ✅ ${readme_rel} 업데이트됨"
	fi
done <<<"$readme_list"

# --check-only: 하나라도 업데이트 필요하면 exit 2
if [ "$mode" = "--check-only" ]; then
	if $needs_update; then
		exit 2
	fi
	exit 0
fi

# --update: stage된 변경이 있으면 커밋
if [ "$mode" = "--update" ]; then
	if $needs_update; then
		git commit -m "docs: update README.md to reflect recent changes"
		echo "  ✅ README.md가 커밋되었습니다."
	else
		echo "  ✅ 실제 변경 사항이 없습니다."
	fi
	exit 0
fi
