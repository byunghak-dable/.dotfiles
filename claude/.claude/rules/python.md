# Python Conventions

- `__init__.py` 사용 금지 — Namespace Packages 사용
- Private 속성은 `@property`로 접근 제어
- **`__` name mangling은 클래스 내부 전용**: module-level private 함수/변수는 `_single_underscore` 사용 (`__`는 클래스 밖에서 mangling이 작동하지 않음)
- **타입 힌트 필수**: 함수 시그니처에 파라미터 타입과 반환 타입 항상 명시
- **`dataclass`/`NamedTuple` 우선**: 구조화된 데이터에 plain dict/tuple 대신 사용
- **f-string 우선**: `format()`, `%` 대신 f-string 사용
