# Agent prompt 템플릿: db-cipher 적용

각 Agent에게 아래 정보를 모두 전달하세요:

```
## 작업 개요
<TICKET> 암호화 마이그레이션 — <repo-name>에 db-cipher 적용

## 대상 정보
(Step 문서의 대상 정보 전체를 복사)

## 코드 수정 주의사항
(references/coding-guidelines.md 내용을 복사)

## 작업 범위
- repo 경로: <repo-path>
- 카테고리: <INSERT/UPDATE/SELECT 등>
- 대상 파일: <파일 목록>

## 작업 절차

### 1. 브랜치 생성
cd <repo-path>
git checkout <default-branch> && git pull
git checkout -b feature/<TICKET>/apply_db_cipher

### 2. 모듈 시스템 감지
- package.json의 "type": "module" 여부
- 기존 .js 파일의 import/require 사용 패턴

### 3. @teamdable/db-cipher 의존성 확인 및 설치
npm ls @teamdable/db-cipher 2>/dev/null
없으면: npm install @teamdable/db-cipher

### 4. 보일러플레이트 코드 생성

**lib/cipher/db_cipher.js** (이미 존재하면 skip):
(CJS/ESM 버전 — 모듈 시스템에 맞게)

**lib/cipher/<테이블명_소문자>_table_cipher.js**:
(Pattern A/B에 맞는 템플릿 제공)

### 5. 쿼리 코드 수정

**Pattern B INSERT/UPDATE 수정:**
- 암호화 대상 컬럼 값을 encrypt 후 encrypted_* 컬럼에 이중 쓰기
- INSERT: encrypted_* 컬럼 및 값 추가
- UPDATE SET: encrypted_* = ? 추가
- 함수가 동기이면 async로 전환

**Pattern B SELECT 수정:**
- SELECT *: encrypted_* 자동 포함되므로 복호화 로직만 추가
- 특정 컬럼 SELECT: encrypted_* 컬럼 명시적 추가
- 기존 동기 직렬화 함수가 있으면:
  → 별도 async 복호화 헬퍼 생성
  → decryptUserRow(row): encrypted_* 존재 시 복호화, delete encrypted_*
  → decryptAndDeserialize(row): decryptUserRow + 기존 deserialize 조합
- .then(rows.map(deserialize)) → Promise.all(rows.map(decryptAndDeserialize))

**Pattern A INSERT/UPDATE 수정:**
- encryptBody() 호출 후 partially_encrypted_* 컬럼에 JSON.stringify 값 추가

**Pattern A SELECT 수정:**
- partially_encrypted_* 존재 시 JSON.parse → decryptPartiallyEncryptedBody
- 없으면 기존 컬럼 값 사용 (fallback)

### 6. 단위 테스트 생성
기존 테스트 디렉토리/패턴을 확인하여 TableCipher 테스트 작성

### 7. 커밋 및 PR
- git add 및 커밋
- git push -u origin feature/<TICKET>/apply_db_cipher
- gh pr create --title "WIP: [<TICKET>] apply db-cipher to <테이블명>" --assignee @me
- **PR URL을 반드시 결과에 포함**
```
