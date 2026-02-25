---
allowed-tools: Bash(git checkout:*), Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git push:*), Bash(git commit:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(git remote:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(cat:*), Bash(mkdir:*)
description: Commit, push, and open a PR using the project PR template
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Default remote branch: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | sed 's/.*: //'`
- Commits on this branch: !`git log --oneline origin/HEAD..HEAD 2>/dev/null || git log --oneline -5`
- PR template: !`cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null || cat .github/pull_request_template.md 2>/dev/null || cat docs/pull_request_template.md 2>/dev/null || echo "__NO_TEMPLATE__"`
- Project commit convention: !`cat .claude/commit-convention.md 2>/dev/null || grep -A 60 -m 1 "## Commit" CLAUDE.md 2>/dev/null || echo "__USE_DEFAULT__"`

## Commit Rules

> **프로젝트 우선**: 위 "Project commit convention"이 `__USE_DEFAULT__`가 아닌 경우, 아래 기본 규칙 대신 해당 내용을 따르세요.

### Default Message Format
```
<type>: <description>
```

| type | 사용 상황 |
|------|----------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `chore` | 빌드, 설정, 리팩토링, 이름 변경 등 기능 외 변경 |
| `refactor` | 기능 변경 없이 코드 구조 개선 |
| `test` | 테스트 추가/수정 |
| `docs` | 문서 수정 |

1. type은 소문자로 작성
2. `git add .` 사용 금지 — 관련 파일만 명시적으로 스테이징
3. secrets 파일 커밋 금지 (`.env`, credentials 등)

## Your Task

**한 번의 응답에서 모든 tool call을 처리하세요.**

### Step 1: 커밋 컨벤션 확인

"Project commit convention"이 `__USE_DEFAULT__`인 경우:
1. `git log --oneline -50`으로 기존 커밋 히스토리를 분석하여 컨벤션 패턴을 파악
2. `.claude/` 디렉토리 생성 후 `.claude/commit-convention.md` 파일을 작성
3. 이후 커밋부터 해당 컨벤션을 적용

### Step 2: 브랜치 확인
- default 브랜치(main/master)라면 적절한 feature 브랜치를 먼저 생성
- 이미 feature 브랜치라면 그대로 진행

### Step 3: 커밋 생성
- 변경 사항을 관심사별로 그룹핑하여 **항상 별도 커밋으로 처리**하세요. 분리 여부를 사용자에게 묻지 않습니다.
- 관심사가 하나인 경우 → 단일 커밋
- 관심사가 여러 개인 경우 → 각각 별도 커밋 (순서대로 처리)

### Step 3: Push
```bash
git push -u origin <branch>
```

### Step 4: PR 생성

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
