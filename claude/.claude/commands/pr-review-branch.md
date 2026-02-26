---
allowed-tools: Read, Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git rev-parse:*)
description: Review branch changes before creating a PR
---

## Context

- Current branch: !`git branch --show-current`
- Branch diff: !`git diff origin/HEAD..HEAD`
- Changed files: !`git diff origin/HEAD..HEAD --name-only`
- Commits on this branch: !`git log --oneline origin/HEAD..HEAD`
- CLAUDE.md (root): !`cat "$(git rev-parse --show-toplevel)/CLAUDE.md" 2>/dev/null || echo "__NONE__"`
- CLAUDE.md (subdirs): !`find "$(git rev-parse --show-toplevel)" -name "CLAUDE.md" -not -path "$(git rev-parse --show-toplevel)/CLAUDE.md" -not -path "*/node_modules/*" -exec echo "--- {} ---" \; -exec cat {} \; 2>/dev/null || echo "__NONE__"`

## Your Task

branch diff가 비어있으면 "origin 대비 변경 사항이 없습니다."를 출력하고 종료하세요.

### 리뷰 수행

아래 리뷰를 수행하세요:

1. **변경 파일의 관련 컨텍스트 읽기**: branch diff에 포함된 각 파일에서 변경된 함수/클래스의 전체 코드와 호출하는 주변 코드를 Read tool로 읽으세요.

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
- 개별 커밋에서 이미 리뷰된 이슈 (브랜치 전체 관점의 이슈만 집중)

### 출력 형식

이슈가 있는 경우:

```
### Branch Review (origin/HEAD..HEAD)

Found N issues:

1. [BUG] 파일:라인 — 설명
2. [CONVENTION] 파일:라인 — 설명 (CLAUDE.md: "관련 규칙")
3. [SECURITY] 파일:라인 — 설명
4. [DESIGN] 파일:라인 — 설명
```

이슈가 없는 경우:

```
### Branch Review (origin/HEAD..HEAD)

No significant issues found.
```
