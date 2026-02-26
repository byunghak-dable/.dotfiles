# Commit Code Review Integration Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** `/commit` 실행 시 각 관심사별 커밋 전에 코드 리뷰를 수행하고, 독립 `/review-staged` 커맨드도 제공한다.

**Architecture:** `review-staged.md` slash command가 staged diff + 관련 컨텍스트를 수집하여 Sonnet agent 1개로 4관점 리뷰 수행. `commit.md`는 각 관심사별 스테이징 후 동일 리뷰 로직을 인라인 수행.

**Tech Stack:** Claude Code slash commands (markdown), Sonnet agent (Task tool)

---

### Task 1: `review-staged.md` slash command 생성

**Files:**

- Create: `claude/.claude/commands/review-staged.md`

**Step 1: 파일 생성**

```markdown
---
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*)
description: Review staged changes before committing
---

## Context

- Staged diff: !`git diff --staged`
- Staged file list: !`git diff --staged --name-only`
- CLAUDE.md (root): !`cat CLAUDE.md 2>/dev/null || echo "__NONE__"`
- CLAUDE.md (subdirs): !`find . -name "CLAUDE.md" -not -path "./CLAUDE.md" -not -path "*/node_modules/*" -exec echo "--- {} ---" \; -exec cat {} \; 2>/dev/null || echo "__NONE__"`

## Your Task

staged diff가 비어있으면 "스테이징된 변경이 없습니다."를 출력하고 종료하세요.

### 리뷰 수행

Sonnet agent 1개를 실행하여 아래 리뷰를 수행하세요:

1. **변경 파일의 관련 컨텍스트 읽기**: staged diff에 포함된 각 파일에서 변경된 함수/클래스의 전체 코드와 호출하는 주변 코드를 읽으세요.

2. **4가지 관점으로 리뷰**:
   - **버그/로직 에러**: 잘못된 조건, off-by-one, null/undefined 처리 누락, 타입 불일치
   - **CLAUDE.md 컨벤션 준수**: 위 Context의 CLAUDE.md 규칙 위반 여부
   - **보안 취약점**: injection, 민감 정보 노출, 안전하지 않은 입력 처리
   - **설계 이슈**: 불필요한 복잡도, 관심사 혼재, 잘못된 추상화

3. **confidence score (0-100)** 기준으로 각 이슈를 평가하고, **70점 이상만** 보고하세요.

### False positive 제외 대상

- linter, typechecker, compiler가 잡을 이슈 (import 누락, 타입 에러, formatting)
- 변경하지 않은 코드의 pre-existing 이슈
- 시니어 엔지니어가 지적하지 않을 사소한 nitpick
- 의도적인 변경으로 보이는 기능 수정

### 출력 형식

이슈가 있는 경우:
```

### Staged Changes Review

Found N issues:

1. [BUG] 파일:라인 — 설명
2. [CONVENTION] 파일:라인 — 설명 (CLAUDE.md: "관련 규칙")
3. [SECURITY] 파일:라인 — 설명
4. [DESIGN] 파일:라인 — 설명

```

이슈가 없는 경우:

```

### Staged Changes Review

No significant issues found.

```

```

**Step 2: 확인**

Run: `cat claude/.claude/commands/review-staged.md | head -5`
Expected: frontmatter가 올바르게 작성되어 있음

**Step 3: Commit**

```bash
git add claude/.claude/commands/review-staged.md
git commit -m "feature: add review-staged slash command for pre-commit code review"
```

---

### Task 2: `commit.md`에 리뷰 단계 통합

**Files:**

- Modify: `claude/.claude/commands/commit.md:62-89` (Your Task 섹션)

**Step 1: commit.md 수정**

"Your Task" 섹션의 Step 2를 확장하여 리뷰 사이클을 통합한다.

기존:

```markdown
### Step 2: 관심사별 커밋 분리

변경 사항을 관심사별로 그룹핑하여 **항상 별도 커밋으로 처리**하세요. ...
```

변경 후:

```markdown
### Step 2: 관심사별 리뷰 & 커밋

변경 사항을 관심사별로 그룹핑하여 **항상 별도 커밋으로 처리**하세요. 분리 여부를 사용자에게 묻지 않습니다.

- 관심사가 하나인 경우 → 단일 커밋
- 관심사가 여러 개인 경우 → 의존성 순서대로 별도 커밋:
```

기반 타입/에러 정의 → 하위 레이어 구현 → 상위 레이어 핸들링 → 테스트

````

**파일 내 일부 변경만 스테이징이 필요한 경우** `git add -p`를 사용하세요:

```bash
git add -p <파일>   # hunk 단위로 선택적 스테이징
````

**각 관심사 그룹 커밋 전 코드 리뷰:**

스테이징 완료 후 커밋 전에 `/review-staged`와 동일한 리뷰를 수행하세요:

1. Sonnet agent 1개로 staged diff + 관련 컨텍스트를 4관점(버그, 컨벤션, 보안, 설계) 리뷰
2. confidence 70+ 이슈만 보고, false positive 제외 (linter가 잡을 이슈, pre-existing, nitpick)
3. 이슈 발견 시 결과를 보여주고 사용자에게 확인: **"이슈를 수정하시겠습니까, 아니면 그대로 커밋하시겠습니까?"**
4. 이슈 없으면 바로 커밋 진행

````

**Step 2: 확인**

Run: `grep -c "review" claude/.claude/commands/commit.md`
Expected: 리뷰 관련 내용이 포함됨

**Step 3: Commit**

```bash
git add claude/.claude/commands/commit.md
git commit -m "feature: integrate pre-commit code review into commit workflow"
````

---

### Task 3: design doc 정리 & 최종 커밋

**Files:**

- Existing: `docs/plans/2026-02-26-commit-code-review-design.md`

**Step 1: Commit design doc**

```bash
git add docs/plans/2026-02-26-commit-code-review-design.md docs/plans/2026-02-26-commit-code-review-plan.md
git commit -m "docs: add design and implementation plan for commit code review"
```
