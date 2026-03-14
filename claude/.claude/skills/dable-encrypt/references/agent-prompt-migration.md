# Agent prompt 참조: 마이그레이션 스크립트 생성

Agent prompt에 포함할 정보:

- Step 문서의 **대상 정보** 전체
- db-cipher 경로
- Pattern A/B에 따른 스크립트 템플릿:

**Pattern A**: encryptFields로 JSON 부분 암호화, 단일 신규 컬럼에 JSON.stringify
**Pattern B**: encrypt로 각 컬럼 개별 암호화, COLUMN_PAIRS 배열 기반

공통 구조:

- mysql2/promise로 DB 연결
- BATCH_SIZE 환경변수 (기본 1000)
- DRY_RUN 환경변수 지원
- 진행률 로깅
- 에러 카운트 및 개별 에러 로깅
- PK 기반 WHERE 절

스크립트 경로: `scripts/migrate-<테이블명_소문자>.js`
