# Rust Conventions

- **`unwrap()`/`expect()` 금지**: production 코드에서 `?` 연산자 사용. 테스트에서만 허용
- **`&str` 우선**: 함수 파라미터에 `String` 대신 `&str`. 소유권이 필요한 경우만 `String`
- **불필요한 `.clone()` 금지**: 소유권/참조로 해결 가능하면 clone 하지 않음
- **`clippy` 준수**: `#[allow(clippy::...)]` 남발 금지. 정당한 사유 있을 때만 주석과 함께 허용
