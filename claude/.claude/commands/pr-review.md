---
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh api:*), Bash(gh pr list:*), Bash(gh pr comment:*), Bash(gh pr review:*), Bash(git log:*), Bash(git blame:*), Bash(cat:*), Read, Glob, Grep, Task
description: PR 코드 품질 심층 리뷰 - 버그, 설계 이슈, 잠재적 문제점 분석
---

## Context

- Current branch: !`git branch --show-current`
- Repository: !`gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null`
- CLAUDE.md: !`cat CLAUDE.md 2>/dev/null | head -50 || echo "__NO_CLAUDE_MD__"`

## Your Task

PR의 코드 품질을 **심층 리뷰**하여 버그, 설계 이슈, 잠재적 문제점을 찾으세요.

Arguments가 없으면 현재 브랜치의 PR을 찾으세요: `gh pr view --json number,url`
Arguments가 PR 번호 또는 URL이면 해당 PR을 리뷰하세요.

### Step 1: PR 정보 수집

병렬로 실행:

```bash
gh pr view <number> --json title,body,files,additions,deletions,baseRefName,headRefName
gh pr diff <number>
```

### Step 2: CLAUDE.md 규칙 수집

Haiku agent로 PR이 수정한 디렉토리의 CLAUDE.md 파일을 모두 찾아 규칙 목록을 수집하세요.

### Step 3: 5개 병렬 Sonnet agent로 리뷰

각 agent에게 PR diff와 관련 컨텍스트를 전달:

| Agent | 역할                | 집중 영역                                           |
| ----- | ------------------- | --------------------------------------------------- |
| #1    | **CLAUDE.md 준수**  | 프로젝트 규칙 위반 여부                             |
| #2    | **버그 탐지**       | 로직 오류, edge case, off-by-one, null/undefined 등 |
| #3    | **설계 분석**       | 아키텍처 적합성, 레이어 위반, 의존성 방향, 응집도   |
| #4    | **보안/성능**       | SQL injection, 메모리 누수, N+1 쿼리, 무한 루프 등  |
| #5    | **테스트 커버리지** | 테스트 누락, edge case 미검증, mock 적절성          |

각 agent는 발견한 이슈를 아래 형식으로 반환:

```
- [severity: critical/major/minor] <이슈 설명>
  파일: <path>:<line>
  근거: <왜 이것이 문제인가>
  제안: <수정 방향>
```

### Step 4: 이슈 검증 및 필터링

각 이슈에 대해 Haiku agent로 신뢰도 점수(0-100)를 매기세요:

| 점수   | 의미                                               |
| ------ | -------------------------------------------------- |
| 0-25   | False positive, 기존 이슈, lint/타입체커가 잡을 것 |
| 25-50  | 가능성 있으나 미검증, 사소한 스타일 이슈           |
| 50-75  | 실제 이슈이나 실무 영향 낮음, nitpick              |
| 75-100 | 검증된 실제 이슈, 기능에 직접 영향                 |

**False positive 기준** (제외 대상):

- 기존 코드의 문제 (PR에서 수정하지 않은 라인)
- Lint, 타입체커, CI가 잡을 이슈
- 의도적 변경으로 보이는 기능 변경
- CLAUDE.md에 명시되지 않은 스타일 nitpick

### Step 5: 결과 출력

**신뢰도 75 이상 이슈만** 최종 리포트에 포함.

````markdown
## PR #<number> 코드 리뷰: `<title>`

### 요약

- 변경 규모: +<additions> / -<deletions> (파일 <count>개)
- 발견 이슈: critical <n>, major <n>, minor <n>

### Issues

#### 1. [critical] <이슈 제목>

**파일:** `<path>:<line>` (신뢰도: <score>)

<문제 설명>

```diff
- <문제 코드>
+ <제안 코드>
```
````

#### 2. [major] ...

### CLAUDE.md 준수 현황

- [x] <준수 항목>
- [ ] <위반 항목> — <설명>

### 추가 권고 (선택)

<심각하지 않지만 개선하면 좋을 사항>

````

이슈가 없으면:

```markdown
## PR #<number> 코드 리뷰: `<title>`

### 요약
변경 규모: +<additions> / -<deletions> (파일 <count>개)

신뢰도 75 이상 이슈 없음. CLAUDE.md 준수 확인 완료.
````

### 옵션: GitHub에 코멘트

사용자가 요청하면 `gh pr comment <number> --body "<리뷰 결과>"` 또는 `gh pr review <number> --comment --body "<리뷰 결과>"`로 PR에 직접 코멘트하세요.
