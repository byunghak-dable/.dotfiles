---
name: dable-encrypt-prepare
disable-model-invocation: true
allowed-tools: Bash(jira issue view:*), Bash(jira issue comment add:*), Bash(gh search code:*), Bash(gh repo view:*), Bash(gh api:*), Bash(gh repo clone:*), Bash(git checkout:*), Bash(git branch:*), Bash(git log:*), Bash(git diff:*), Bash(git push:*), Bash(git remote:*), Bash(git status:*), Bash(git rev-parse:*), Bash(git pull:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(gh label list:*), Bash(npm install:*), Bash(npm ls:*), Bash(find:*), Bash(cat:*), Bash(ls:*), Bash(cd:*), Bash(jq:*), Bash(grep:*), Read, Write, Edit, Glob, Grep, Agent(subagent_type=Explore), AskUserQuestion
description: DB 컬럼 암호화 마이그레이션 준비 — JIRA 파싱 → 의존성 탐색 → JIRA 댓글 → data-schema DDL PR → 의존 repo db-cipher PR
---

## Context

- JIRA 티켓: $ARGUMENTS
- GitHub 조직: teamdable
- db-cipher repo: teamdable/db-cipher
- data-schema repo: teamdable/data-schema

## Your Task

DB 컬럼 암호화 마이그레이션의 Phase 1을 수행합니다:
1. JIRA 카드에서 암호화 대상 테이블 정보 파싱
2. GitHub org-wide 코드 검색으로 의존 Repository 탐색
3. JIRA 카드에 작업 범위 댓글 작성
4. data-schema에 신규 암호화 컬럼 DDL PR 생성
5. 의존 Repository별 db-cipher 적용 코드 + PR 생성

---

### Step 1: JIRA 카드 파싱 및 정보 수집

`$ARGUMENTS`가 없으면 AskUserQuestion으로 JIRA 티켓 키를 요청하세요.

```bash
jira issue view <TICKET> --raw
```

description에서 아래 정보를 추출하세요. **표준 형식이 아니더라도 유연하게 파싱**합니다:

**테이블 레벨 정보** (스칼라):

| # | 항목 | 예시 | 파싱 힌트 |
|---|------|------|----------|
| 1 | 서버 | AD, RECO, DMP | db-cipher의 SENSITIVE_TABLE_CONFIG_BY_DB 키 |
| 2 | 데이터베이스 | AD_ADMIN, DABLE | `{서버}_{...}` 형태 또는 DDL 경로에서 추론 |
| 3 | 테이블명 | ACCOUNT_REQUEST | 대문자 + 언더스코어 패턴 |

**컬럼 레벨 정보** (배열 — 복수 행 가능):

| # | 항목 | 예시 | 비고 |
|---|------|------|------|
| 4 | 컬럼명 | body, email, phone | 암호화 대상 원본 컬럼. 복수 가능 |
| 5 | 타입 | mediumtext, varchar(255) | DDL에서 확인 가능 |
| 6 | 민감 필드 | email, phone, name | JSON 내 부분 암호화 대상 키. 전체 암호화면 빈칸 |

**표준 테이블 형식** (권장 — 복수 행 지원):
```
| 서버 | 데이터베이스 | 테이블 | 컬럼명 | 타입 | 민감 필드 |
```
- 행이 1개면 단일 컬럼 (기존과 동일)
- 행이 N개면 복수 컬럼 (서버/DB/테이블이 빈 행은 직전 행 값 상속)

**비표준 형식 대응**: description이 표준 형식이 아닌 경우 (예: 자유 텍스트, 다른 테이블 형식):
1. description 내용에서 테이블명, 컬럼명 등을 최대한 추출
2. 추출한 정보를 사용자에게 보여주고 확인 요청
3. 누락된 항목은 개별적으로 AskUserQuestion으로 요청

**정보 누락 시 자동 해결 + 개별 질문** (한 번에 모든 것을 묻지 말고, 단계적으로):

1. 서버명 자동 해결 (GitHub에서 constants.ts 조회):
   ```bash
   # db-cipher constants.ts에서 테이블명으로 서버키 자동 추출
   gh api repos/teamdable/db-cipher/contents/src/common/constants.ts -H "Accept: application/vnd.github.raw+json" | grep -B 10 "<TABLE>"
   ```
   - `SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>` 경로에서 서버키 추출
   - 찾으면 자동 사용, 못 찾으면 AskUserQuestion: "이 테이블의 서버명을 알려주세요"

2. 컬럼 타입 확인 (GitHub에서 DDL 조회 + 불일치 검증):
   ```bash
   gh api repos/teamdable/data-schema/contents/rds/<db(소문자)>/<TABLE>.sql -H "Accept: application/vnd.github.raw+json"
   ```
   - DDL에서 각 컬럼의 타입을 추출
   - **DDL 불일치 검증**: JIRA에 있지만 DDL에 없는 컬럼이 있으면 AskUserQuestion:
     "JIRA에 `<컬럼명>`이 있지만 DDL에는 없습니다. 이 컬럼을 암호화 대상에 포함할까요? DDL이 최신이 아닐 수 있습니다."
   - DDL에서도 전혀 확인 불가하면 AskUserQuestion으로 타입 요청

3. 민감 필드를 알 수 없으면:
   - AskUserQuestion: "이 컬럼은 JSON Object인가요? JSON이라면 암호화할 필드명을 알려주세요 (예: email, phone, name)"
   - 참고 링크 제공: [데이터베이스 개인정보 관리 시트](https://docs.google.com/spreadsheets/d/10Nx_Thi2cfblUegiXAHXzUyANt2FaUPV/edit?gid=2055106771#gid=2055106771)

**암호화 패턴 자동 판별** (컬럼별 민감 필드 유무로 결정):

| 패턴 | 조건 | 신규 컬럼 접두사 | db-cipher API |
|------|------|----------------|---------------|
| **Pattern A** (JSON 부분 암호화) | 민감 필드 있음 | `partially_encrypted_` | `encryptFields`/`decryptFields` |
| **Pattern B** (개별 컬럼 전체 암호화) | 민감 필드 없음 | `encrypted_` | `encrypt`/`decrypt` |

- 모든 컬럼의 민감 필드가 비어있으면 → Pattern B (복수 개별 컬럼)
- 민감 필드가 있는 컬럼이 있으면 → Pattern A (JSON 부분 암호화)

**최종 확인**: 모든 정보를 수집한 후 AskUserQuestion으로 요약을 보여주고 확인받으세요:

Pattern A 예시 (단일 JSON 컬럼):
```
암호화 대상 확인:
- 서버: AD / DB: AD_ADMIN / 테이블: ACCOUNT_REQUEST
- 패턴: Pattern A (JSON 부분 암호화)
- 원본 컬럼: body (mediumtext)
- 신규 컬럼: partially_encrypted_body
- 민감 필드: email, phone, name
```

Pattern B 예시 (복수 개별 컬럼):
```
암호화 대상 확인:
- 서버: AD / DB: AD_ADMIN / 테이블: USER
- 패턴: Pattern B (개별 컬럼 전체 암호화)
- 대상 컬럼 (7개):
  1. user_name (varchar(100)) → encrypted_user_name
  2. email (varchar(255)) → encrypted_email
  3. report_emails (text) → encrypted_report_emails
  4. phone (varchar(100)) → encrypted_phone
  5. login_id (varchar(45)) → encrypted_login_id
  6. login_pw (varchar(100)) → encrypted_login_pw
  7. agreed_ip (varchar) → encrypted_agreed_ip
```

---

### Step 2: 의존 Repository 탐색

병렬로 2가지 탐색을 수행:

**2a. GitHub org-wide 코드 검색**

```bash
gh search code "<테이블명>" --owner teamdable --json repository,path,textMatches -L 100
```

결과에서:
- node_modules, test, spec, mock, fixture, migration 경로는 제외
- data-schema 레포는 제외
- 실제 SQL 쿼리나 모델에서 테이블을 참조하는 코드만 필터링

**2b. data-schema DDL 확인**

```bash
gh api repos/teamdable/data-schema/contents/rds/<데이터베이스(소문자)>/<테이블명>.sql -H "Accept: application/vnd.github.raw+json"
```

현재 DDL에서 컬럼 목록을 확인하세요.

**결과 분류**: 각 의존 repo의 코드를 분석하여 카테고리 분류

| 카테고리 | 키워드 패턴 |
|---------|-----------|
| INSERT  | `INSERT INTO`, `insert into` |
| UPDATE  | `UPDATE ...SET`, `update ...set` |
| SELECT  | `SELECT`, `select`, `findAll`, `findOne`, `fetch` |

AskUserQuestion으로 탐색 결과를 보여주고 사용자 확인을 받으세요:
- **결과 확인 완료** — 이대로 진행합니다
- **레포 추가/제거** — 의존 레포 목록을 수정합니다

---

### Step 3: JIRA 카드에 작업 범위 댓글 작성

아래 형식으로 댓글을 작성하세요:

```bash
cat <<'EOF' | jira issue comment add <TICKET> --template -
> 마이그레이션 진행 순서(예상)

1. DB 암호화 컬럼 생성
   1. 암호화 컬럼은 암호화 여부를 확인할 수 있도록 접미사 추가
      - 일반 컬럼: … + `encrypted`
      - JSON 컬럼: … + `partially_encrypted`
   2. 초기 컬럼 세팅은 nullable로 세팅
2. 암호화 모듈 적용
   1. INSERT, UPDATE 작업이 있는 부분 우선적으로 마이그레이션
   2. 스크립트를 통해 마이그레이션 대상 컬럼 데이터와 암호화 컬럼 데이터 싱크
   3. SELECT 작업이 있는 부분 마이그레이션
3. 기능 이상 여부 확인 및 기존 컬럼 제거

> 테이블 의존성 파악

- INSERT
  - <repo-name> (<파일 경로 링크>)
- UPDATE
  - <repo-name> (<파일 경로 링크>)
- SELECT
  - <repo-name> (<파일 경로 링크>)
EOF
```

GitHub 파일 링크 형식: `https://github.com/teamdable/<repo>/blob/<default-branch>/<path>#L<line>`

---

### Step 4: data-schema PR 생성

**로컬 경로 확인**: data-schema 레포를 로컬에서 찾고, 없으면 clone:
```bash
REPO_PATH=$(find ~/dev -maxdepth 3 -type d -name "data-schema" 2>/dev/null | head -1)
if [ -z "$REPO_PATH" ]; then
  gh repo clone teamdable/data-schema /tmp/data-schema
  REPO_PATH="/tmp/data-schema"
fi
```

data-schema 레포로 이동하여:

1. 최신 default 브랜치를 pull:
   ```bash
   cd $REPO_PATH
   git checkout <default-branch> && git pull
   ```

2. `/branch` command 패턴으로 브랜치 생성:
   ```bash
   git checkout -b feature/<TICKET>/add_encrypted_column
   ```

3. DDL 파일 수정 (`rds/<데이터베이스(소문자)>/<테이블명>.sql`):
   - 마지막 컬럼 뒤에 **모든 신규 암호화 컬럼** DDL 추가 (columns 배열 순회)
   - Pattern A (민감 필드 있음): `` `partially_encrypted_<컬럼명>` <타입> CHARACTER SET utf8 COMMENT '<설명: 개인정보 필드 값이 암호화되어 있음>' ``
   - Pattern B (민감 필드 없음): `` `encrypted_<컬럼명>` text CHARACTER SET utf8 COMMENT '<설명: 값이 암호화되어 있음>' ``
     - **타입 주의**: Pattern B의 encrypted 컬럼은 AES-256-GCM + Base64로 원본보다 길어지므로 `text` 사용 권장. 다른 타입이 필요하면 AskUserQuestion으로 확인
   - **주의**: mediumtext/longtext에 DEFAULT 사용 불가 (MySQL 5.x 제약)
   - nullable로 설정 (NOT NULL 없음) — 마이그레이션 완료 전까지

4. `/commit` command 패턴으로 커밋:
   ```bash
   git add <DDL 파일>
   git commit -m "feature: add encrypted column(s) for <테이블명>"
   ```

5. `/pr-push` command 패턴으로 PR 생성:
   - 제목: `[<TICKET>] add encrypted column(s) for <테이블명>`
   - PR template이 있으면 해당 형식 사용
   - label: `enhancement`

---

### Step 5: 의존 Repository별 db-cipher 적용 + PR

**각 의존 repo에 대해 순차적으로 수행** (사용자 확인을 받으며 진행):

#### 5a. 로컬 경로 확인

의존 repo를 로컬에서 찾고, 없으면 clone:
```bash
REPO_PATH=$(find ~/dev -maxdepth 3 -type d -name "<repo-name>" 2>/dev/null | head -1)
if [ -z "$REPO_PATH" ]; then
  gh repo clone teamdable/<repo-name> /tmp/<repo-name>
  REPO_PATH="/tmp/<repo-name>"
fi
```

clone도 실패하면 AskUserQuestion으로 skip 선택지를 제공하세요.

#### 5b. 브랜치 생성

```bash
cd <repo-path>
git checkout <default-branch> && git pull
git checkout -b feature/<TICKET>/apply_db_cipher
```

#### 5c. 모듈 시스템 감지

repo의 기존 코드가 ESM(`import/export`)인지 CJS(`require/module.exports`)인지 판단:
- `package.json`의 `"type": "module"` 여부
- 기존 `.js` 파일의 import/require 사용 패턴

#### 5d. SENSITIVE_TABLE_CONFIG_BY_DB 등록 확인

db-cipher의 constants.ts에서 해당 테이블이 등록되어 있는지 확인:
```bash
gh api repos/teamdable/db-cipher/contents/src/common/constants.ts -H "Accept: application/vnd.github.raw+json" | grep -A 5 "<TABLE>"
```

등록되어 있지 않으면 AskUserQuestion으로 안내:
- "SENSITIVE_TABLE_CONFIG_BY_DB에 <TABLE>이 등록되어 있지 않습니다. db-cipher에 먼저 등록해야 합니다. 직접 등록하시겠습니까, 아니면 이 단계를 건너뛰시겠습니까?"

#### 5e. @teamdable/db-cipher 의존성 확인

```bash
npm ls @teamdable/db-cipher 2>/dev/null
```

없으면:
```bash
npm install @teamdable/db-cipher
```

#### 5f. 보일러플레이트 코드 생성

**`lib/cipher/db_cipher.js`** (이미 존재하면 skip):

CJS 버전:
```javascript
const { DbCipherImpl } = require('@teamdable/db-cipher');

const dbCipher = DbCipherImpl.init(process.env.NODE_ENV === 'production');

module.exports = { dbCipher };
```

ESM 버전:
```javascript
import { DbCipherImpl } from '@teamdable/db-cipher';

export const dbCipher = DbCipherImpl.init(process.env.NODE_ENV === 'production');
```

**`lib/cipher/<테이블명_소문자>_table_cipher.js`** — Pattern에 따라 다른 템플릿 사용:

**Pattern A (JSON 부분 암호화)** — CJS 버전:
```javascript
const { SENSITIVE_TABLE_CONFIG_BY_DB } = require('@teamdable/db-cipher');
const { dbCipher } = require('./db_cipher');

class <TableName>TableCipher {
  #cipher;
  #tableConfig;

  constructor(cipher) {
    this.#cipher = cipher;
    this.#tableConfig = SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>;
  }

  async encryptBody(body) {
    return this.#cipher.encryptFields(this.#buildBodyCipherParams(body));
  }

  async decryptPartiallyEncryptedBody(partiallyEncryptedBody) {
    return this.#cipher.decryptFields(this.#buildBodyCipherParams(partiallyEncryptedBody));
  }

  #buildBodyCipherParams(data) {
    const SENSITIVE_KEYS = [<민감 필드 목록>];
    return { tableConfig: this.#tableConfig, data, keys: SENSITIVE_KEYS };
  }
}

const <tableName>TableCipher = new <TableName>TableCipher(dbCipher);

module.exports = { <tableName>TableCipher, <TableName>TableCipher };
```

**Pattern B (개별 컬럼 전체 암호화)** — CJS 버전:
```javascript
const { SENSITIVE_TABLE_CONFIG_BY_DB } = require('@teamdable/db-cipher');
const { dbCipher } = require('./db_cipher');

class <TableName>TableCipher {
  #cipher;
  #tableConfig;

  constructor(cipher) {
    this.#cipher = cipher;
    this.#tableConfig = SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>;
  }

  async encrypt(value) {
    if (!value) {
      return value;
    }
    return this.#cipher.encrypt(this.#tableConfig, value);
  }

  async decrypt(encryptedValue) {
    if (!encryptedValue) {
      return encryptedValue;
    }
    return this.#cipher.decrypt(this.#tableConfig, encryptedValue);
  }
}

const <tableName>TableCipher = new <TableName>TableCipher(dbCipher);

module.exports = { <tableName>TableCipher, <TableName>TableCipher };
```

- Pattern B는 generic `encrypt`/`decrypt`만 제공 (컬럼별 메서드 불필요 — 동일한 tableConfig + DEK 사용)
- null/빈값 가드 포함 (nullable 컬럼 대응)

**공통 네이밍 규칙**:
- `<TableName>`: PascalCase (예: AccountRequest, User)
- `<tableName>`: camelCase (예: accountRequest, user)
- `<SERVER>`, `<DB>`, `<TABLE>`: JIRA에서 파싱한 값 그대로
- Pattern A: `<민감 필드 목록>` = `'email', 'phone', 'name'` 형태

#### 5g. 쿼리 코드 수정

Step 2에서 분류한 카테고리별로 코드를 수정합니다. **Pattern에 따라 다른 패턴 적용**:

---

**Pattern A (JSON 부분 암호화)**:

INSERT/UPDATE 수정:
```javascript
const partiallyEncryptedBody = await <tableName>TableCipher.encryptBody(<원본데이터>);
// INSERT/UPDATE 쿼리에 partially_encrypted_<컬럼명> 컬럼 및 JSON.stringify(partiallyEncryptedBody) 값 추가
```

SELECT 수정:
```javascript
if (row.partially_encrypted_<컬럼명>) {
  const encrypted = JSON.parse(row.partially_encrypted_<컬럼명>);
  const decrypted = await <tableName>TableCipher.decryptPartiallyEncryptedBody(encrypted);
  Object.assign(row.<컬럼명>, decrypted);
}
delete row.partially_encrypted_<컬럼명>;
```

---

**Pattern B (개별 컬럼 전체 암호화)** — 모든 대상 컬럼에 대해 반복:

INSERT/UPDATE 수정:
```javascript
// 모든 대상 컬럼에 대해 암호화
const encryptedUserName = await <tableName>TableCipher.encrypt(data.user_name);
const encryptedEmail = await <tableName>TableCipher.encrypt(data.email);
const encryptedPhone = await <tableName>TableCipher.encrypt(data.phone);
// ... 모든 대상 컬럼

// INSERT 쿼리에 encrypted_* 컬럼 및 값 추가
// UPDATE SET 절에 encrypted_* = ? 추가
```

SELECT 수정:
```javascript
// SELECT 필드에 모든 encrypted_* 컬럼 추가
// 조회 후 각 컬럼 복호화 + fallback:
if (row.encrypted_user_name) {
  row.user_name = await <tableName>TableCipher.decrypt(row.encrypted_user_name);
}
delete row.encrypted_user_name;

if (row.encrypted_email) {
  row.email = await <tableName>TableCipher.decrypt(row.encrypted_email);
}
delete row.encrypted_email;
// ... 모든 대상 컬럼에 대해 반복
```

---

**중요**: 기존 코드의 스타일(들여쓰기, 세미콜론, 따옴표 등)을 유지하세요.

#### 5h. 단위 테스트 생성

기존 테스트 디렉토리/패턴을 확인하여 `<TableName>TableCipher`의 encrypt/decrypt 테스트를 작성:

**Pattern A**:
```javascript
const mockCipher = {
  encryptFields: jest.fn(),
  decryptFields: jest.fn(),
};

expect(mockCipher.encryptFields).toHaveBeenCalledWith({
  tableConfig: expect.objectContaining({ table: '<TABLE>' }),
  data: <원본데이터>,
  keys: [<민감 필드 목록>],
});
```

**Pattern B**:
```javascript
const mockCipher = {
  encrypt: jest.fn().mockResolvedValue('encrypted_value'),
  decrypt: jest.fn().mockResolvedValue('decrypted_value'),
};

it('encrypt: tableConfig를 전달하여 값을 암호화한다', async () => {
  const cipher = new <TableName>TableCipher(mockCipher);
  await cipher.encrypt('plaintext');
  expect(mockCipher.encrypt).toHaveBeenCalledWith(
    expect.objectContaining({ table: '<TABLE>' }),
    'plaintext'
  );
});

it('encrypt: falsy 값은 그대로 반환한다', async () => {
  const cipher = new <TableName>TableCipher(mockCipher);
  const result = await cipher.encrypt(null);
  expect(result).toBeNull();
  expect(mockCipher.encrypt).not.toHaveBeenCalled();
});
```

#### 5i. 커밋 및 PR

1. `/commit` command 패턴으로 커밋
2. `/pr-push` command 패턴으로 PR 생성:
   - 제목: `[<TICKET>] apply db-cipher to <테이블명>`
   - body에 JIRA 링크 포함
   - label: `enhancement`

#### 5j. 다음 repo 진행 전 확인

AskUserQuestion으로 선택지 제공:
- **다음 repo 진행** — 다음 의존 repo로 이동합니다
- **현재 repo 수정** — 생성된 코드를 수정합니다
- **나머지 skip** — 나머지 repo는 건너뜁니다

---

### Step 6: 완료 요약

모든 작업이 끝나면 아래 내용을 출력하세요:

```
## 암호화 마이그레이션 Phase 1 완료

### 생성된 PR 목록
- data-schema: <PR URL>
- <repo-1>: <PR URL>
- <repo-2>: <PR URL>
...

### 다음 단계
Phase 2 (데이터 마이그레이션)를 진행하려면: /dable-encrypt-migrate <TICKET>
```
