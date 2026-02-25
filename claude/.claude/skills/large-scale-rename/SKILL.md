---
name: large-scale-rename
description: Use when asked to rename a symbol, type, method, variable, or constant across the entire codebase. Applies when the rename touches more than 2-3 files or crosses layer boundaries. Examples: "tablePath를 tableConfig로 바꿔주세요", "전체적으로 이름 변경이 필요합니다".
---

# Large-Scale Rename

## Overview

코드베이스 전체에 걸친 리네이밍을 체계적으로 실행한다.
누락 없이 일관되게 변경하고, 타입 에러로 검증한다.

## Process

### 1단계: 리네이밍 맵 정의

작업 전 Before → After 테이블을 명시한다:

| Before                   | After                      | 대상               |
| ------------------------ | -------------------------- | ------------------ |
| `tablePath`              | `tableConfig`              | 파라미터명, 변수명 |
| `SensitiveTablePath`     | `SensitiveTableConfig`     | 타입명             |
| `TablePathNotFoundError` | `TableConfigNotFoundError` | 에러 클래스명      |
| `fetchByTablePath`       | `fetchByTableConfig`       | 메소드명           |

### 2단계: 영향 범위 탐색

```bash
# 정확한 문자열 검색
grep -rn "tablePath" src/ --include="*.ts"

# 타입 참조 포함
grep -rn "SensitiveTablePath" src/ --include="*.ts"

# 테스트 포함 전체 탐색
grep -rn "tablePath\|SensitiveTablePath" . \
  --include="*.ts" \
  --exclude-dir=node_modules
```

탐색 결과를 카테고리별로 분류:

- **타입 정의** (interface, type alias, class)
- **메소드/함수 시그니처** (파라미터명, 반환 타입)
- **변수/상수** (let, const, 클래스 필드)
- **에러 클래스명**
- **문자열 리터럴** (로그, 에러 메시지)
- **주석**

### 3단계: 영향 범위 보고 → 승인 요청

변경 전 영향 범위를 사용자에게 공유한다:

```
변경 예정 파일:
- src/common/types.ts (타입 정의 2곳)
- src/application/cipher_service.ts (파라미터명 5곳)
- src/infrastructure/dek_storage_client.ts (메소드 시그니처 3곳)
- test/cipher_service.spec.ts (테스트 변수명 8곳)

총 18곳 변경 예정
```

### 4단계: 레이어 순서대로 변경

의존성이 낮은 곳(하위)부터 변경:

```
1. 공통 타입/에러 정의 (common/)
2. 도메인 레이어 (domain/)
3. 인프라 레이어 (infrastructure/)
4. 애플리케이션 레이어 (application/)
5. 테스트 (test/)
```

### 5단계: 타입 체크로 누락 확인

```bash
# TypeScript
npx tsc --noEmit

# Python (pyright)
pyright src/
```

에러가 있으면 해당 위치로 돌아가 수정.

## 주의 사항

| 상황                                          | 처리                                                   |
| --------------------------------------------- | ------------------------------------------------------ |
| 문자열 리터럴 안 이름 (Secret Manager key 등) | **변경하지 않음** - 외부 시스템과 계약이므로 별도 확인 |
| public API / export된 타입                    | 하위 호환성 확인 후 변경                               |
| 테스트 파일                                   | 구현 변경 후 마지막에 변경                             |
| 주석                                          | 코드 변경과 함께 업데이트                              |

## Common Mistakes

| 실수                        | 교정                               |
| --------------------------- | ---------------------------------- |
| `sed -i` 전체 치환으로 시작 | 탐색 → 범위 확인 → 순차 변경       |
| 문자열 리터럴까지 변경      | 코드 심볼과 문자열을 구분해서 처리 |
| 타입 체크 없이 완료 선언    | `tsc --noEmit` 통과 후 완료        |
| 테스트 먼저 변경            | 구현 코드 변경 후 테스트           |
