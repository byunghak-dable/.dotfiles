# General Rules (일반 규칙)

- **접근법 거부 시**: 즉시 멈추고 방향을 물어볼 것. 대안을 반복적으로 추측하지 말 것
- **변경 범위**: 명시적으로 요청된 것만 변경할 것. 추가 개선이 필요하다고 판단되면 먼저 물어볼 것
- **정보의 정확성**: 확인되지 않은 정보를 사실처럼 제시하지 말 것. 불확실하면 명시적으로 밝힐 것
- **커밋 금지**: 명시적으로 요청받기 전까지 절대 커밋하지 말 것
- **리팩토링**: 항상 가장 단순한 방법을 먼저 시도. 접근법 거부 시 완전히 롤백 후 대안 시도
- **코드 수정 전 검증**: 반드시 관련 코드를 실제로 읽어 가정을 검증할 것
- **파일 수정 후 Formatter 실행**: 프로젝트 설정 파일(Makefile, package.json, pyproject.toml)에서 formatter를 판단하여 실행. 없으면 물어볼 것

# Communication (커뮤니케이션)

- 응답/설명: **한국어** | 기술 용어: **영문 유지** | 에러 메시지: **영어**
- 코드 주석: **한국어**, 의도 중심 (설명이 아닌 why)
- 맥락 중심의 간결한 기술적 답변

# Code Principles (언어 공통)

- **fail-fast**: validation 실패 시 skip/warn 금지, 즉시 `raise`/`throw`. 불필요한 try-catch 래핑 금지
- **불필요한 Optional 분기 금지**: 런타임에 항상 존재하는 값은 필수 타입으로 선언. 진입점에서 검증 후 이후 로직은 분기 없이 단순하게
- **접근 제어 엄격 적용**: Private(`__name`/`#name`), Protected(`_name`), Public(`name`) — 내부 전용 속성/메소드에 `_`(single underscore) 하나로 퉁치지 말 것. 반드시 접근 수준에 맞는 prefix 사용

# Python Conventions

- `__init__.py` 사용 금지 — Namespace Packages 사용
- Private 속성은 `@property`로 접근 제어

# TypeScript Conventions

- **Destructuring 우선**: 함수 파라미터 `({ server, db }: Config)`, 변수 할당 `const { path } = obj`
- **파라미터 3개 이상 → Object 형태**, 공개 API 타입은 `type.ts`에 정의
- **Early Return**: 반드시 중괄호 블록 (`if (x) return;` ❌ → `if (x) { return; }` ✅)
- **길이/존재 확인**: `!arr.length` (Truthy/Falsy 사용)
- **상수**: UPPER_SNAKE_CASE (중첩 객체 프로퍼티 포함)
- **문자열 결합**: 구분자 있으면 `[a, b].join(":")`

# Database Guidelines

- **MySQL DDL 제약**: MySQL 5.x는 `mediumtext`/`longtext`에 `DEFAULT` 불가. DDL 제안 전 DB 버전 확인

# Context Management

- compaction 시 수정된 파일 목록과 테스트 명령어는 반드시 보존할 것
