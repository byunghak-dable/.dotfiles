---
name: python-oop-review
description: Use when writing or reviewing Python code, before committing Python files, or when told code violates OOP conventions. Proactively checks private/protected naming, unnecessary Optional branching, and SOLID violations per CLAUDE.md Python guidelines.
---

# Python OOP Review

## Overview

Python 코드 작성/수정 시 CLAUDE.md의 Python 코딩 가이드라인을 자동으로 점검한다.
반복 지적 패턴을 사전에 차단하는 것이 목적이다.

## 점검 체크리스트

### 1. 접근 제어자 (가장 빈번한 실수)

```python
# ❌ Bad - 외부 접근 금지 의도인데 single underscore
class CtrModel:
    def _fit(self, X, y): ...          # 실제로 완전 비공개라면

# ✅ Good
class CtrModel:
    def __fit(self, X, y): ...         # 완전 비공개 (클래스 내부 전용)
    def _prepare_features(self): ...   # protected (서브클래스 접근 허용)
```

**기준:**
| 의도 | prefix |
|------|--------|
| 클래스 내부 전용, 외부/서브클래스 모두 접근 금지 | `__` (double) |
| 서브클래스에서 접근 가능, 외부 비공개 | `_` (single) |
| 공개 API | 없음 |

### 2. 불필요한 Optional 분기

```python
# ❌ Bad - 항상 존재하는 값에 Optional 사용 → 불필요한 분기 발생
def train(self, sample_weights: Optional[pd.Series] = None):
    if sample_weights is not None:
        self.__model.fit(X, y, sample_weight=sample_weights)
    else:
        self.__model.fit(X, y)

# ✅ Good - 필수 값은 필수 타입으로, 진입점에서 검증 후 조기 실패
def train(self, sample_weights: pd.Series):
    self.__model.fit(X, y, sample_weight=sample_weights)
```

**확인 포인트:**

- 런타임에 항상 값이 있는데 `Optional`인가?
- 진입점(use case)에서 `raise`로 검증하면 이후 분기가 필요 없는가?
- 동일 함수 내 직전에 할당한 변수를 `is not None` 체크하는가?

### 3. 단일 책임 원칙

클래스 작성 시 책임 목록을 나열해보고 2개 이상이면 분리 검토:

```python
# ❌ Bad
class TrainingService:
    def train(self): ...
    def send_slack_alert(self): ...   # 별도 클래스
    def upload_to_s3(self): ...       # 별도 클래스

# ✅ Good - 각 책임을 별도 클래스로
class TrainingService:
    def __init__(self, notifier: Notifier, storage: Storage):
        self.__notifier = notifier
        self.__storage = storage
    def train(self): ...
```

### 4. `__init__.py` 사용 금지

```
# ❌ Bad
mypackage/__init__.py  존재

# ✅ Good - namespace package
from mypackage.module import MyClass  # 직접 import
```

## 빠른 점검 커맨드

```bash
# private 의도인데 single underscore인 메소드 탐색
grep -n "    def _[^_]" <파일>

# Optional 사용처 확인
grep -n "Optional\[" <파일>
```

## Common Mistakes

| 실수                                        | 교정                         |
| ------------------------------------------- | ---------------------------- |
| `def _validate_internal()` (내부 전용)      | `def __validate_internal()`  |
| `Optional[Config]` (항상 주입되는 의존성)   | `Config` 필수 타입으로 변경  |
| `if config is not None:` 반복 분기          | 진입점 검증 + 분기 제거      |
| `__init__.py` 생성                          | 삭제, namespace package 사용 |
| `sample_weights: Optional[...]` (항상 있음) | `sample_weights: pd.Series`  |
