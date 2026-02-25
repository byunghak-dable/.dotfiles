---
name: split-commits
description: Use when asked to commit changes with multiple distinct logical units, or when told to "변경점별로 커밋 분리" or "커밋을 나눠서". Applies when git diff contains changes across different concerns (e.g., new error class + handler update + test). Do NOT use for single-concern changes.
---

# Split Commits

## Overview

여러 관심사가 섞인 변경을 의미 단위별로 분리하여 커밋한다.
각 커밋은 하나의 완결된 변경 단위여야 하며, 이력을 봤을 때 의도가 명확히 드러나야 한다.

## When to Use

- "변경점별로 커밋 분리해주세요" 요청 시
- `git diff`에 서로 다른 관심사(새 타입 추가 / 기존 로직 수정 / 테스트)가 섞인 경우
- 단일 커밋이 너무 크거나 메시지가 모호해지는 경우

**사용하지 않는 경우:** 단일 파일의 단일 수정처럼 자연스럽게 커밋 1개가 되는 경우

## Process

### 1단계: 변경 분석

```bash
git diff HEAD --stat          # 파일 목록과 변경 규모
git diff HEAD -- <파일>       # 파일별 상세 내용
git status                    # 추적/미추적 파일
```

변경을 **논리 그룹**으로 분류한다:

| 그룹 유형 | 예시 |
|-----------|------|
| 새 타입/에러 클래스 추가 | `DekAlreadyExistsError` 클래스 신규 |
| 인터페이스/로직 변경 | storage client에서 에러 throw 추가 |
| 상위 레이어 핸들링 | service에서 race condition 처리 |
| 리팩토링/이름 변경 | tablePath → tableConfig 리네이밍 |
| 설정/인프라 | 버전 업, CI 설정 |

### 2단계: 그룹별 커밋 순서 결정

의존성 방향대로 정렬한다:
```
기반 타입/에러 정의 → 하위 레이어 구현 → 상위 레이어 핸들링 → 테스트
```

### 3단계: 파일 단위 스테이징 + 커밋

```bash
# 특정 파일만 스테이징
git add src/common/errors/dek_already_exists_error.ts
git commit -m "feat: add DekAlreadyExistsError"

# 파일 내 일부 변경만 스테이징
git add -p src/infrastructure/dek_storage_client.ts
git commit -m "feat: throw DekAlreadyExistsError when secret already exists"

# 나머지 커밋
git add src/application/cipher_service.ts
git commit -m "fix: handle race condition by re-fetching on DekAlreadyExistsError"
```

## Commit Message Convention

```
<type>: <description>

type: feat | fix | chore | refactor | test | docs
```

- 한 커밋 = 한 문장으로 설명 가능해야 함
- 이미 있는 커밋 이력의 스타일을 `git log --oneline -10`으로 확인 후 맞춤

## Common Mistakes

| 실수 | 수정 |
|------|------|
| 모든 파일을 `git add .`으로 한번에 | 파일별/섹션별로 스테이징 |
| 리팩토링 + 기능 추가를 한 커밋에 | 반드시 분리 |
| "WIP", "update" 같은 모호한 메시지 | type + 구체적 행위 명시 |
| 테스트와 구현을 항상 같은 커밋에 | 구현 선 커밋, 테스트 후 커밋도 가능 |
