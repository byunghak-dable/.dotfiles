# Go Conventions

- **`Get` prefix 금지**: getter에 `Get` 접두사 사용하지 않음 (`GetName()` ❌ → `Name()` ✅)
- **에러 wrapping**: `return err` 금지. `fmt.Errorf("context: %w", err)`로 컨텍스트 추가
- **`panic` 금지 (라이브러리)**: 라이브러리 코드에서 panic 대신 error 반환. main/테스트에서만 허용
- **interface는 소비자 측에 정의**: 생산자가 interface를 만들지 않음. 필요한 쪽에서 최소 interface 정의
- **`init()` 지양**: 암묵적 초기화 대신 명시적 생성자 함수 사용
