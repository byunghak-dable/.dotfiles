---
allowed-tools: Read, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git push:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(git remote:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(gh label list:*), Bash(cat:*)
description: Review branch, push, and create or update a PR with auto-inferred assignee/labels
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
5. 이슈 발견 시 결과를 보여주고 AskUserQuestion으로 선택지 제공:
   - **수정** — 이슈를 수정한 뒤 진행합니다
   - **그대로 진행** — 이슈를 무시하고 push합니다
6. 이슈 없으면 Step 2로 진행

### Step 2: Push

```bash
git push -u origin <branch>
```

### Step 3: PR 존재 여부 확인

```bash
gh pr view --json number,title,body,url,assignees,labels
```

- PR이 존재하면 → **Step 4a** (업데이트)
- PR이 없으면 → **Step 4b** (신규 생성)

### Step 4a: PR 업데이트 (기존 PR이 있는 경우)

**먼저 body 업데이트 필요 여부를 판단:**

기존 PR body에 아직 반영되지 않은 커밋들을 분석하여 다음 기준으로 분류:

- **주요 변경** (body 업데이트 필요): 새 파일 추가, 아키텍처 변경, 동작 변경, 새 기능
- **마이너 변경** (push만으로 충분): 기존 변경의 연장선인 bugfix, config 참조 수정, typo, 린트 수정, 리네이밍

**마이너 변경만 있는 경우** → body 업데이트 없이 PR URL만 출력하고 종료

**주요 변경이 포함된 경우:**

1. 현재 커밋들 기반으로 title, body를 재생성 (Step 4b의 title/body 작성 규칙과 동일)
2. `gh pr edit <number> --title "<title>" --body "$(cat <<'EOF' ... EOF)"`로 업데이트
3. assignee/label 처리:
   - 기존 PR에 assignee가 비어있으면 → **Assignee/Label 자동 추론** 수행
   - 기존 PR에 label이 비어있으면 → **Assignee/Label 자동 추론** 수행
   - 이미 설정되어 있으면 유지

### Step 4b: PR 신규 생성 (기존 PR이 없는 경우)

**Assignee/Label 자동 추론**을 먼저 수행한 뒤 PR을 생성합니다.

**PR 제목**: `[JIRA-TICKET] <description>` 형식으로 작성 (type prefix 없음)

- 브랜치명에서 티켓 패턴 추출 (예: `BE-1376`, `SUPPORT-3210`, `PROJ-123`)
- 티켓을 찾을 수 없으면 사용자에게 JIRA 번호를 확인 요청
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
)" --assignee <assignee> --label <label>
```

---

## Assignee/Label 자동 추론

### Assignee

- 기본값: `@me`

### Label

브랜치명 prefix에서 추론:

| 브랜치 prefix                | Label           |
| ---------------------------- | --------------- |
| `feature/`, `feat/`          | `enhancement`   |
| `fix/`, `bugfix/`, `hotfix/` | `bug`           |
| `refactor/`                  | `refactor`      |
| `docs/`                      | `documentation` |
| `chore/`                     | `chore`         |

- 매칭되는 prefix가 없으면 → `gh label list`로 사용 가능한 label 목록을 가져와 AskUserQuestion으로 선택지 제공

### 확인 절차

추론 결과를 보여준 후 AskUserQuestion으로 선택지를 제공하세요:

- **이대로 진행** — 추론된 assignee/label로 PR을 생성합니다
- **변경** — assignee 또는 label을 수정합니다
