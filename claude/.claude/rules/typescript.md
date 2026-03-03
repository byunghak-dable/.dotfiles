# TypeScript Conventions

- **Destructuring 우선**: 함수 파라미터 `({ server, db }: Config)`, 변수 할당 `const { path } = obj`
- **파라미터 3개 이상 → Object 형태**, 공개 API 타입은 `type.ts`에 정의
- **중괄호 필수**: 모든 제어문(if, for, while 등)에 중괄호 블록 사용. 한줄 선언 지양 (`if (x) return;` ❌ → `if (x) { return; }` ✅)
- **길이/존재 확인**: `!arr.length` (Truthy/Falsy 사용)
- **상수**: UPPER_SNAKE_CASE (중첩 객체 프로퍼티 포함)
- **문자열 결합**: 구분자 있으면 `[a, b].join(":")`
- **모듈 시스템 유지**: require/import 중 파일 내 기존 방식을 유지. "통일" = 동일 방식으로 일관성 확보 (모듈 시스템 전환 아님)
