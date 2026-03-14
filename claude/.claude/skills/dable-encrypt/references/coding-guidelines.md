# 코드 수정 시 주의사항

Agent에게 작업을 위임할 때 반드시 아래 주의사항을 prompt에 포함하세요.

## 1. SELECT \* 와 encrypted\_\_ 컬럼

`SELECT *` 사용 시 encrypted\_\* 컬럼이 결과에 자동 포함됩니다.

- 별도로 SELECT 목록에 추가할 필요 없음
- **복호화 로직만 추가**하면 됨 (결과 행에서 encrypted\_\* 읽고 delete)
- 특정 컬럼만 SELECT하는 경우에만 encrypted\_\* 컬럼을 명시적으로 추가

## 2. 동기 → 비동기 전환

기존 코드의 직렬화/역직렬화 함수(`deserialize`, `serialize` 등)가 **동기 함수**인 경우가 많습니다.
decrypt는 비동기이므로:

- 기존 동기 함수는 그대로 유지
- **별도의 async 복호화 헬퍼**를 만들어 SELECT 결과에 적용
- `.then(rows => rows.map(deserialize))` → `Promise.all(rows.map(decryptAndDeserialize))` 패턴 사용
- 함수 시그니처가 `function` → `async function`으로 변경될 수 있으므로, 호출부 영향도 확인

## 3. MySQL `SET ?` (객체 기반 UPDATE) 패턴

MySQL의 `UPDATE table SET ?` 패턴에서 `?`에 객체를 전달하는 경우:

- 객체에 encrypted\_\* 프로퍼티를 추가하거나
- `SET ?, encrypted_xxx = ?` 형태로 추가 파라미터를 별도 전달
- 기존 객체 구조를 변경하지 않도록 주의
