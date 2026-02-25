# Code Principles (언어 공통)

- **fail-fast**: validation 실패 시 skip/warn 금지, 즉시 `raise`/`throw`. 불필요한 try-catch 래핑 금지
- **불필요한 Optional 분기 금지**: 런타임에 항상 존재하는 값은 필수 타입으로 선언. 진입점에서 검증 후 이후 로직은 분기 없이 단순하게
- **접근 제어 엄격 적용**: Private(`__name`/`#name`), Protected(`_name`), Public(`name`) — 내부 전용 속성/메소드에 `_`(single underscore) 하나로 퉁치지 말 것. 반드시 접근 수준에 맞는 prefix 사용
