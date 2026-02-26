---
allowed-tools: Read, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git push:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(git remote:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(cat:*)
description: Review branch, push, and open a PR using the project PR template
---

## Context

- Current branch: !`git branch --show-current`
- Default remote branch: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | sed 's/.*: //'`
- Commits on this branch: !`git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline -5`
- PR template: !`cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null || cat .github/pull_request_template.md 2>/dev/null || cat docs/pull_request_template.md 2>/dev/null || echo "__NO_TEMPLATE__"`

## Your Task

### Step 1: Branch Diff 리뷰

`/pr-review-branch`와 동일한 리뷰를 수행하세요:

1. `git diff origin/HEAD..HEAD`로 전체 branch diff를 확인
2. 변경 파일의 관련 컨텍스트를 Read tool로 읽기
3. 4관점(버그, 컨벤션, 보안, 설계) 리뷰, confidence 70+ 이슈만 보고
4. false positive 제외 (linter가 잡을 이슈, pre-existing, nitpick)
5. 이슈 발견 시 결과를 보여주고 사용자에게 확인: **"이슈를 수정하시겠습니까, 아니면 그대로 진행하시겠습니까?"**
6. 이슈 없으면 Step 2로 진행

### Step 2: Push

```bash
git push -u origin <branch>
```

### Step 3: PR 생성

**PR 제목**: `[JIRA-TICKET] <description>` 형식으로 작성 (type prefix 없음)

- 브랜치명에서 티켓 패턴 추출 (예: `BE-1376`, `SUPPORT-3210`, `PROJ-123`)
- 티켓을 찾을 수 없으면 `[JIRA]` 생략
- 예: `[BE-1376] add r7i.xlarge instance type to node pool`

**PR body 작성 규칙:**

**[PR template이 있는 경우]** — `__NO_TEMPLATE__`가 아닌 경우:

template 구조를 그대로 유지하면서 각 섹션을 아래 규칙으로 채우세요:

- **JIRA / Jira / Notion 섹션**:
  브랜치명에서 티켓 패턴 추출 (예: `BE-1376`, `SUPPORT-3210`, `PROJ-123`)
  plain URL 형식으로 삽입: `https://teamdable.atlassian.net/browse/BE-1376`
  브랜치명에서 티켓을 찾을 수 없으면 `N/A`

- **Changes 섹션**:
  이 브랜치의 커밋 목록과 변경 파일을 분석하여 bullet point로 작성

- **Why 섹션**:
  커밋 메시지와 변경 코드를 분석하여 변경 이유/목적을 작성

- **체크리스트 섹션**:
  각 항목을 변경 내용 기준으로 판단하여 처리:
  - `[ ]` 형식이면 → 해당하면 `[x]`, 미해당이면 `[ ]` 로 체크
  - 서술형(`Y/N`) 형식이면 → 판단 결과를 그대로 기입

**[PR template이 없는 경우]**:

```markdown
## JIRA

https://teamdable.atlassian.net/browse/TICKET

## Changes

- <변경 내용 bullet point>

## Why

- <변경 이유>
```

**PR 생성 명령:**

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
<완성된 PR body>
EOF
)"
```
