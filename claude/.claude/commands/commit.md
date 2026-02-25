---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git commit:*)
description: Create a git commit following team conventions
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`
- Project commit convention: !`cat .claude/commit-convention.md 2>/dev/null || grep -A 60 -m 1 "## Commit" CLAUDE.md 2>/dev/null || echo "__USE_DEFAULT__"`

## Commit Rules

> **프로젝트 우선**: 위 "Project commit convention"이 `__USE_DEFAULT__`가 아닌 경우, 아래 기본 규칙 대신 해당 내용을 따르세요.

### Default Message Format

```
<type>: <description>
```

### Allowed Types

| type | 사용 상황 |
|------|----------|
| `feature` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `chore` | 빌드, 설정, 리팩토링, 이름 변경 등 기능 외 변경 |
| `refactor` | 기능 변경 없이 코드 구조 개선 |
| `test` | 테스트 추가/수정 |
| `docs` | 문서 수정 |

### Rules

1. **type은 소문자**로 작성 (`Feature` ❌ → `feature` ✅)
2. **description은 영어 소문자**로 시작, 마침표 없이
3. **한 커밋 = 한 가지 관심사** — 섞이면 커밋 분리 (`/split-commits` 사용)
4. **`git add .` 사용 금지** — 관련 파일만 명시적으로 스테이징
5. **secrets 파일 커밋 금지** (`.env`, credentials 등)
6. description은 **무엇을(what)이 아닌 왜(why)/어떤 행위**를 표현

### Good Examples

```
feature: add DekAlreadyExistsError for duplicate secret detection
fix: handle race condition in fetchOrCreateDek by re-fetching on conflict
chore: rename tablePath to tableConfig for consistency
refactor: extract dek generation to private method
```

### Bad Examples

```
FEATURE: Update code            ← 대문자, 모호한 설명
fix: fixed bug                  ← 중복 표현
chore: update                   ← 너무 모호
feature: add feature and fix bug  ← 두 가지 관심사 혼재
```

## Your Task

위 규칙을 준수하여 변경 사항에 맞는 커밋을 생성하세요.

- 여러 관심사가 섞인 경우: 커밋을 분리할지 사용자에게 먼저 물어보세요
- 단일 관심사인 경우: 바로 스테이징 후 커밋 생성

한 번의 응답에서 스테이징과 커밋을 모두 처리하세요.
