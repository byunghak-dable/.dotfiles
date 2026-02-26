# Commit/PR 시 코드 리뷰 통합

## 개요

`/commit` 실행 시 각 관심사별 커밋 전에, `/pr-create` 실행 시 push 전에 자동으로 코드 리뷰를 수행한다.
리뷰 결과를 사용자에게 보여주고, 사용자가 진행 여부를 판단한다.

## 구조

### 파일

- `claude/.claude/commands/review-staged.md` — staged diff 리뷰 (독립 command)
- `claude/.claude/commands/commit.md` — 커밋 시 리뷰 통합
- `claude/.claude/commands/pr-review-branch.md` — branch diff 리뷰 (독립 command)
- `claude/.claude/commands/pr-create.md` — PR 생성 시 리뷰 통합 (create-pr.md에서 이름 변경)

### 흐름

```
/commit 실행
  → Step 1: 커밋 컨벤션 확인
  → Step 2: 관심사별 분리 & 커밋
      각 관심사 그룹마다:
        1. 스테이징
        2. 리뷰 (review-staged 로직 수행)
        3. 이슈 있으면 → 사용자에게 수정/진행 확인
        4. 커밋
```

`/review-staged` 단독 실행 시 staged diff만 리뷰하고 종료.

## review-staged.md 설계

### Context 자동 수집

- `git diff --staged` — 변경 내용
- `git diff --staged --name-only` — 변경 파일 목록
- `CLAUDE.md` — 프로젝트 규칙
- 하위 디렉토리 `CLAUDE.md` — 디렉토리별 규칙

### 리뷰 방식

- Sonnet agent 1개 실행
- staged diff + 변경 파일의 관련 컨텍스트(주변 함수/클래스) 읽기
- 4가지 관점 리뷰:
  1. 버그/로직 에러
  2. CLAUDE.md 컨벤션 준수
  3. 보안 취약점
  4. 설계 이슈

### 필터링

- confidence score 0-100 기준 70점 이상만 보고
- false positive 제외 대상:
  - linter/typechecker가 잡을 이슈
  - pre-existing 이슈 (변경하지 않은 코드)
  - 사소한 nitpick

### 출력 형식

```
### Staged Changes Review

Found N issues:

1. [BUG] 파일:라인 — 설명
2. [CONVENTION] 파일:라인 — 설명 (CLAUDE.md: "관련 규칙")
3. [SECURITY] 파일:라인 — 설명
4. [DESIGN] 파일:라인 — 설명

(이슈 없는 경우)
No significant issues found.
```

## commit.md 수정 범위

- Step 2를 확장: 각 관심사 그룹 커밋 전 리뷰 사이클 추가
- 리뷰 로직은 `/review-staged`와 동일하게 수행 (인라인 참조)
- 이슈 발견 시 사용자에게 "수정 / 그대로 커밋" 확인

## pr-review-branch.md 설계

### Context 자동 수집

- `git diff origin/HEAD..HEAD` — 브랜치 전체 변경 내용
- `git diff origin/HEAD..HEAD --name-only` — 변경 파일 목록
- `git log --oneline origin/HEAD..HEAD` — 커밋 목록
- `CLAUDE.md` — 프로젝트 규칙
- 하위 디렉토리 `CLAUDE.md` — 디렉토리별 규칙

### 리뷰 방식

- review-staged.md와 동일한 4관점 리뷰
- 브랜치 전체 diff 기반 — 커밋 단위가 아닌 전체 변경 관점
- 개별 커밋에서 이미 리뷰된 이슈는 제외, 브랜치 전체 관점의 이슈만 집중

### 출력 형식

```
### Branch Review (origin/HEAD..HEAD)

Found N issues:

1. [BUG] 파일:라인 — 설명
2. [CONVENTION] 파일:라인 — 설명 (CLAUDE.md: "관련 규칙")
3. [SECURITY] 파일:라인 — 설명
4. [DESIGN] 파일:라인 — 설명
```

## pr-create.md 설계

### 흐름

```
/pr-create 실행
  → Step 1: Branch diff 리뷰 (pr-review-branch 로직 수행)
      이슈 있으면 → 사용자에게 수정/진행 확인
  → Step 2: Push
  → Step 3: PR 생성
```

- create-pr.md에서 이름 변경 + 리뷰 단계 추가
- 리뷰를 push 전에 배치하여 이슈 발견 시 수정 후 push 가능

## 결정 사항

- 리뷰 범위: 변경 코드 + 관련 컨텍스트
- 결과 처리: 사용자 판단 (게이트 아님)
- Agent 전략: 단일 Sonnet agent
- 관심사별 리뷰: 각 커밋 단위마다 별도 리뷰 실행
- PR 리뷰: 브랜치 전체 diff 기반, push 전 수행
- 리뷰 패턴 일관성: staged/branch 모두 동일한 4관점 + confidence 필터링
