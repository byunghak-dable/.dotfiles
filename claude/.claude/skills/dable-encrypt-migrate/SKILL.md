---
name: dable-encrypt-migrate
disable-model-invocation: true
allowed-tools: Bash(jira issue view:*), Bash(jira issue comment add:*), Bash(gh api:*), Bash(gh repo clone:*), Bash(node:*), Bash(npx:*), Bash(find:*), Bash(cat:*), Bash(ls:*), Bash(cd:*), Bash(jq:*), Bash(grep:*), Bash(mysql:*), Bash(git checkout:*), Bash(git branch:*), Bash(git log:*), Bash(git diff:*), Bash(git push:*), Bash(git remote:*), Bash(git status:*), Bash(git rev-parse:*), Bash(git pull:*), Read, Write, Edit, Glob, Grep, AskUserQuestion
description: DB 컬럼 암호화 데이터 마이그레이션 — 기존 데이터를 암호화하여 신규 컬럼에 채우기
---

## Context

- JIRA 티켓: $ARGUMENTS
- GitHub 조직: teamdable
- db-cipher repo: teamdable/db-cipher
- data-schema repo: teamdable/data-schema

## Your Task

DB 컬럼 암호화 마이그레이션의 Phase 2를 수행합니다:
기존 컬럼 데이터를 읽어 db-cipher로 암호화한 후 신규 컬럼에 채우는 마이그레이션 스크립트를 생성하고 실행합니다.

---

### Step 1: JIRA 카드 파싱 및 정보 수집

`$ARGUMENTS`가 없으면 AskUserQuestion으로 JIRA 티켓 키를 요청하세요.

```bash
jira issue view <TICKET> --raw
```

description에서 테이블 정보를 추출하세요 (encrypt-prepare Step 1과 동일한 파싱 로직):
- 테이블 레벨: 서버, 데이터베이스, 테이블명
- 컬럼 레벨 (배열): 컬럼명, 타입, 민감 필드
- 암호화 패턴 자동 판별: 민감 필드 있음 → Pattern A (`partially_encrypted_*`), 없음 → Pattern B (`encrypted_*`)

**서버명 자동 해결**: JIRA에 서버 정보가 없으면 GitHub에서 constants.ts 조회:
```bash
gh api repos/teamdable/db-cipher/contents/src/common/constants.ts -H "Accept: application/vnd.github.raw+json" | grep -B 10 "<TABLE>"
```
- `SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>` 경로에서 서버키 추출
- 못 찾으면 AskUserQuestion으로 요청

**비표준 형식 대응**: description이 표준 형식이 아닌 경우:
1. 추출 가능한 정보를 최대한 파싱
2. 누락 항목은 AskUserQuestion으로 단계적 요청
3. 참고: [데이터베이스 개인정보 관리 시트](https://docs.google.com/spreadsheets/d/10Nx_Thi2cfblUegiXAHXzUyANt2FaUPV/edit?gid=2055106771#gid=2055106771)

**PK 컬럼명 확인** (마이그레이션 스크립트에서 WHERE 절에 사용):
```bash
gh api repos/teamdable/data-schema/contents/rds/<db(소문자)>/<TABLE>.sql -H "Accept: application/vnd.github.raw+json" | grep -i "PRIMARY KEY"
```
- DDL에서 PK를 확인할 수 없으면 AskUserQuestion: "이 테이블의 Primary Key 컬럼명을 알려주세요 (예: pkid, id, idx)"
- 기본값 `pkid`이지만 반드시 확인 후 사용

**최종 확인**: 모든 정보를 수집한 후 AskUserQuestion으로 요약을 보여주고 확인받으세요:

Pattern A (단일 JSON 컬럼):
```
마이그레이션 대상 확인:
- 서버: AD / DB: AD_ADMIN / 테이블: ACCOUNT_REQUEST
- 패턴: Pattern A (JSON 부분 암호화)
- 원본 컬럼: body (mediumtext) → partially_encrypted_body
- PK 컬럼: <PK 컬럼명>
- 민감 필드: email, phone, name
```

Pattern B (복수 개별 컬럼):
```
마이그레이션 대상 확인:
- 서버: AD / DB: AD_ADMIN / 테이블: USER
- 패턴: Pattern B (개별 컬럼 전체 암호화)
- PK 컬럼: user_id
- 대상 컬럼 (7개):
  1. user_name → encrypted_user_name
  2. email → encrypted_email
  ...
```

---

### Step 2: 마이그레이션 환경 확인

**db-cipher 로컬 경로 확인**: 로컬에서 찾고, 없으면 clone:
```bash
DB_CIPHER_PATH=$(find ~/dev -maxdepth 3 -type d -name "db-cipher" 2>/dev/null | head -1)
if [ -z "$DB_CIPHER_PATH" ]; then
  gh repo clone teamdable/db-cipher /tmp/db-cipher
  DB_CIPHER_PATH="/tmp/db-cipher"
fi
```

**mysql2 의존성 확인**:
```bash
cd $DB_CIPHER_PATH && npm ls mysql2 2>/dev/null
```
없으면 사용자에게 설치 안내: `npm install mysql2`

AskUserQuestion으로 확인 (multiSelect=false, 하나씩 질문):
1. **DB 접속 방식**: 환경변수(DB_HOST, DB_USER 등) / SSH 터널 / 직접 접속
2. **실행 환경**: 로컬 / 서버 (어디에서 스크립트를 실행할지)
3. **batch size**: 기본값 1000 (사용자 조정 가능)
4. **dry-run 먼저 실행 여부**: 기본 Yes

---

### Step 3: 마이그레이션 스크립트 생성

db-cipher 디렉토리 내에 `scripts/migrate-<테이블명_소문자>.js` 파일을 생성합니다.
**Pattern에 따라 다른 스크립트 템플릿을 사용**합니다.

#### Pattern A 스크립트 (JSON 부분 암호화):

```javascript
/**
 * [<TICKET>] <테이블명> 기존 데이터 → 암호화 컬럼 마이그레이션
 *
 * 사용법:
 *   DRY_RUN=true node scripts/migrate-<테이블명>.js     # dry-run
 *   node scripts/migrate-<테이블명>.js                    # 실제 실행
 *
 * 환경변수:
 *   DB_HOST, DB_USER, DB_PASSWORD, DB_PORT
 *   NODE_ENV (production일 때 prod DEK 사용)
 *   DRY_RUN (true일 때 실제 UPDATE 미수행)
 *   BATCH_SIZE (기본값: 1000)
 */

const mysql = require('mysql2/promise');
const { DbCipherImpl, SENSITIVE_TABLE_CONFIG_BY_DB } = require('../src');

const BATCH_SIZE = parseInt(process.env.BATCH_SIZE || '1000', 10);
const DRY_RUN = process.env.DRY_RUN === 'true';
const TABLE_CONFIG = SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>;

async function main() {
  const dbCipher = DbCipherImpl.init(process.env.NODE_ENV === 'production');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: parseInt(process.env.DB_PORT || '3306', 10),
    database: '<데이터베이스명>',
  });

  try {
    // 총 대상 행 수 확인
    const [[{ total }]] = await connection.query(
      'SELECT COUNT(*) AS total FROM <테이블명> WHERE <신규컬럼명> IS NULL OR <신규컬럼명> = ""'
    );
    console.log(`총 마이그레이션 대상: ${total}건 (batch size: ${BATCH_SIZE})`);

    if (DRY_RUN) {
      console.log('[DRY-RUN] 실제 UPDATE는 수행하지 않습니다.');
    }

    let processed = 0;
    let errors = 0;

    while (true) {
      const [rows] = await connection.query(
        'SELECT <PK>, <컬럼명> FROM <테이블명> WHERE <신규컬럼명> IS NULL OR <신규컬럼명> = "" LIMIT ?',
        [BATCH_SIZE]
      );

      if (!rows.length) {
        break;
      }

      for (const row of rows) {
        try {
          const data = JSON.parse(row.<컬럼명>);
          const encrypted = await dbCipher.encryptFields({
            tableConfig: TABLE_CONFIG,
            data,
            keys: [<민감 필드 목록>],
          });

          if (!DRY_RUN) {
            await connection.query(
              'UPDATE <테이블명> SET <신규컬럼명> = ? WHERE <PK> = ?',
              [JSON.stringify(encrypted), row.<PK>]
            );
          }

          processed++;
        } catch (err) {
          errors++;
          console.error(`[ERROR] <PK>=${row.<PK>}: ${err.message}`);
        }
      }

      const progress = ((processed + errors) / total * 100).toFixed(1);
      console.log(`진행: ${processed}/${total} (${progress}%) | 에러: ${errors}`);
    }

    console.log(`\n완료: 성공 ${processed}건, 에러 ${errors}건`);
  } finally {
    await connection.end();
  }
}

main().catch((err) => {
  console.error('마이그레이션 실패:', err);
  process.exit(1);
});
```

**Pattern A 주의사항**:
- PK 컬럼명은 Step 1에서 확인한 값을 사용 (`<PK>` placeholder를 실제 PK로 교체)
- SENSITIVE_TABLE_CONFIG_BY_DB에 해당 테이블이 등록되어 있는지 확인:
  ```bash
  gh api repos/teamdable/db-cipher/contents/src/common/constants.ts -H "Accept: application/vnd.github.raw+json" | grep -A 5 "<TABLE>"
  ```
  등록되어 있지 않으면 AskUserQuestion: "SENSITIVE_TABLE_CONFIG_BY_DB에 <TABLE>이 등록되어 있지 않습니다. 먼저 db-cipher에 등록이 필요합니다."

---

#### Pattern B 스크립트 (개별 컬럼 전체 암호화):

```javascript
/**
 * [<TICKET>] <테이블명> 기존 데이터 → 암호화 컬럼 마이그레이션
 *
 * 사용법:
 *   DRY_RUN=true node scripts/migrate-<테이블명>.js     # dry-run
 *   node scripts/migrate-<테이블명>.js                    # 실제 실행
 *
 * 환경변수:
 *   DB_HOST, DB_USER, DB_PASSWORD, DB_PORT
 *   NODE_ENV (production일 때 prod DEK 사용)
 *   DRY_RUN (true일 때 실제 UPDATE 미수행)
 *   BATCH_SIZE (기본값: 1000)
 */

const mysql = require('mysql2/promise');
const { DbCipherImpl, SENSITIVE_TABLE_CONFIG_BY_DB } = require('../src');

const BATCH_SIZE = parseInt(process.env.BATCH_SIZE || '1000', 10);
const DRY_RUN = process.env.DRY_RUN === 'true';
const TABLE_CONFIG = SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>;

// 마이그레이션 대상 컬럼 매핑
const COLUMN_PAIRS = [
  { original: '<컬럼명1>', encrypted: 'encrypted_<컬럼명1>' },
  { original: '<컬럼명2>', encrypted: 'encrypted_<컬럼명2>' },
  // ... 모든 대상 컬럼
];

async function main() {
  const dbCipher = DbCipherImpl.init(process.env.NODE_ENV === 'production');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: parseInt(process.env.DB_PORT || '3306', 10),
    database: '<데이터베이스명>',
  });

  try {
    // WHERE 조건: 첫 번째 encrypted 컬럼이 NULL인 행
    const whereClause = `${COLUMN_PAIRS[0].encrypted} IS NULL`;
    const originalColumns = COLUMN_PAIRS.map(({ original }) => original).join(', ');
    const encryptedSetClause = COLUMN_PAIRS.map(({ encrypted }) => `${encrypted} = ?`).join(', ');

    const [[{ total }]] = await connection.query(
      `SELECT COUNT(*) AS total FROM <테이블명> WHERE ${whereClause}`
    );
    console.log(`총 마이그레이션 대상: ${total}건 (batch size: ${BATCH_SIZE})`);

    if (DRY_RUN) {
      console.log('[DRY-RUN] 실제 UPDATE는 수행하지 않습니다.');
    }

    let processed = 0;
    let errors = 0;

    while (true) {
      const [rows] = await connection.query(
        `SELECT <PK>, ${originalColumns} FROM <테이블명> WHERE ${whereClause} LIMIT ?`,
        [BATCH_SIZE]
      );

      if (!rows.length) {
        break;
      }

      for (const row of rows) {
        try {
          // 모든 컬럼을 한 번에 암호화 (Promise.all 병렬 처리)
          const encryptedValues = await Promise.all(
            COLUMN_PAIRS.map(async ({ original }) => {
              const value = row[original];
              if (!value) {
                return value;
              }
              return dbCipher.encrypt(TABLE_CONFIG, String(value));
            })
          );

          if (!DRY_RUN) {
            await connection.query(
              `UPDATE <테이블명> SET ${encryptedSetClause} WHERE <PK> = ?`,
              [...encryptedValues, row.<PK>]
            );
          }

          processed++;
        } catch (err) {
          errors++;
          console.error(`[ERROR] <PK>=${row.<PK>}: ${err.message}`);
        }
      }

      const progress = ((processed + errors) / total * 100).toFixed(1);
      console.log(`진행: ${processed}/${total} (${progress}%) | 에러: ${errors}`);
    }

    console.log(`\n완료: 성공 ${processed}건, 에러 ${errors}건`);
  } finally {
    await connection.end();
  }
}

main().catch((err) => {
  console.error('마이그레이션 실패:', err);
  process.exit(1);
});
```

**Pattern B 주의사항**:
- `COLUMN_PAIRS` 배열에 모든 대상 컬럼 매핑을 기입
- `String(value)`: encrypt API가 string만 받으므로 타입 변환 필요
- WHERE 절: 첫 번째 encrypted 컬럼 기준 (모든 컬럼이 동시에 마이그레이션되므로)
- `<PK>`: Step 1에서 확인한 PK 컬럼명으로 교체
- SENSITIVE_TABLE_CONFIG_BY_DB 등록 확인: Pattern A와 동일

---

### Step 4: 사용자 확인

생성된 스크립트를 보여주고 AskUserQuestion으로 선택지 제공:
- **dry-run 실행** — DRY_RUN=true로 먼저 실행합니다
- **스크립트 수정** — 스크립트 내용을 수정합니다
- **저장만** — 스크립트를 저장하고 수동 실행합니다

---

### Step 5: 실행 (사용자 승인 시)

```bash
cd $DB_CIPHER_PATH
DRY_RUN=true node scripts/migrate-<테이블명>.js
```

dry-run 결과를 보여준 후:
- **실제 실행** — DRY_RUN 없이 실행합니다
- **중단** — 여기서 멈춥니다

---

### Step 6: 완료 후

1. 실행 결과 요약 출력
2. JIRA 카드에 마이그레이션 결과 댓글 작성:

```bash
cat <<'EOF' | jira issue comment add <TICKET> --template -
## 데이터 마이그레이션 완료

- 대상 테이블: <테이블명>
- 총 처리: <N>건
- 성공: <N>건
- 에러: <N>건
- 실행 시간: <시간>

### 다음 단계
Phase 3 (기존 컬럼 제거)를 진행하려면 의존 repo PR 머지 확인 후 진행
EOF
```

3. 안내 메시지:
```
다음 단계: /dable-encrypt-cleanup <TICKET>
```
