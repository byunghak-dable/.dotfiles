---
name: dable-encrypt-cleanup
disable-model-invocation: true
allowed-tools: Bash(jira issue view:*), Bash(jira issue comment add:*), Bash(gh search code:*), Bash(gh repo view:*), Bash(gh api:*), Bash(gh repo clone:*), Bash(find:*), Bash(git checkout:*), Bash(git branch:*), Bash(git log:*), Bash(git diff:*), Bash(git push:*), Bash(git remote:*), Bash(git status:*), Bash(git rev-parse:*), Bash(git pull:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(gh label list:*), Bash(cat:*), Bash(ls:*), Bash(cd:*), Bash(jq:*), Bash(grep:*), Read, Write, Edit, Glob, Grep, AskUserQuestion
description: DB 컬럼 암호화 정리 — 기존 컬럼 참조 제거 + DDL 정리 + JIRA 완료 댓글
---

## Context

- JIRA 티켓: $ARGUMENTS
- GitHub 조직: teamdable
- db-cipher repo: teamdable/db-cipher
- data-schema repo: teamdable/data-schema

## Your Task

DB 컬럼 암호화 마이그레이션의 Phase 3을 수행합니다:
기존 평문 컬럼을 제거하고, 암호화 컬럼만 사용하도록 코드를 정리합니다.

**주의**: 이 command는 Phase 1(encrypt-prepare) 및 Phase 2(encrypt-migrate)가 완료되고, 모든 PR이 머지된 후에 실행해야 합니다.

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

**서버명 자동 해결**: JIRA에 서버 정보가 없으면 GitHub에서 constants.ts를 조회하여 테이블명으로 검색:
```bash
gh api repos/teamdable/db-cipher/contents/src/common/constants.ts \
  -H "Accept: application/vnd.github.raw+json" | grep -B 10 "<TABLE>"
```
- `SENSITIVE_TABLE_CONFIG_BY_DB.<SERVER>.<DB>.<TABLE>` 경로에서 서버키 추출
- 못 찾으면 AskUserQuestion으로 요청

**비표준 형식 대응**: description이 표준 형식이 아닌 경우:
1. 추출 가능한 정보를 최대한 파싱
2. 누락 항목은 AskUserQuestion으로 단계적 요청

**최종 확인**: AskUserQuestion으로 요약을 보여주고 확인받으세요:

Pattern A (단일 JSON 컬럼):
```
정리 대상 확인:
- 서버: AD / DB: AD_ADMIN / 테이블: ACCOUNT_REQUEST
- 기존 컬럼(제거 대상): body
- 암호화 컬럼(유지): partially_encrypted_body
```

Pattern B (복수 개별 컬럼):
```
정리 대상 확인:
- 서버: AD / DB: AD_ADMIN / 테이블: USER
- 기존 컬럼(제거 대상): user_name, email, report_emails, phone, login_id, login_pw, agreed_ip
- 암호화 컬럼(유지): encrypted_user_name, encrypted_email, ...
```

---

### Step 2: 사전 확인

AskUserQuestion으로 체크리스트 확인 (multiSelect=true):
- **Phase 1 PR 머지 완료** — 의존 repo에 db-cipher 적용 PR이 모두 머지되었는지
- **Phase 2 마이그레이션 완료** — 기존 데이터가 모두 암호화 컬럼으로 마이그레이션되었는지
- **신규 컬럼에 NULL/빈값 없음** — 마이그레이션 누락 없는지

하나라도 미완료이면 해당 단계를 먼저 완료하도록 안내하고 중단합니다:
- Phase 1 미완료 → `/dable-encrypt-prepare <TICKET>` 안내
- Phase 2 미완료 → `/dable-encrypt-migrate <TICKET>` 안내

---

### Step 3: 의존 Repository 코드 정리

Phase 1에서 작성한 JIRA 댓글의 의존성 목록을 참고하거나, 다시 `gh search code`로 탐색합니다.

각 의존 repo에 대해:

#### 3a. 로컬 경로 확인 및 브랜치 생성

의존 repo가 로컬에 clone 되어 있는지 확인하고, 없으면 `/tmp`에 clone:
```bash
REPO_PATH=$(find ~/dev -maxdepth 3 -type d -name "<repo-name>" 2>/dev/null | head -1)
if [ -z "$REPO_PATH" ]; then
  gh repo clone teamdable/<repo-name> /tmp/<repo-name>
  REPO_PATH="/tmp/<repo-name>"
fi
```

```bash
cd $REPO_PATH
git checkout <default-branch> && git pull
git checkout -b feature/<TICKET>/remove_plaintext_column
```

#### 3b. fallback 로직 제거

기존 코드에서 아래 패턴을 찾아 정리합니다. **Pattern에 따라 다른 패턴 적용**:

---

**Pattern A (JSON 부분 암호화)**:

Before (이중 쓰기):
```javascript
INSERT INTO table (body, partially_encrypted_body) VALUES (?, ?)
```
After:
```javascript
INSERT INTO table (partially_encrypted_body) VALUES (?)
```

Before (SELECT fallback):
```javascript
if (row.partially_encrypted_body) { /* 복호화 */ } else { /* 기존 body 사용 */ }
```
After:
```javascript
const encrypted = JSON.parse(row.partially_encrypted_body);
const decrypted = await tableCipher.decryptPartiallyEncryptedBody(encrypted);
Object.assign(row.body, decrypted);
```

---

**Pattern B (개별 컬럼 전체 암호화)** — 모든 대상 컬럼에 대해 반복:

Before (이중 쓰기):
```javascript
INSERT INTO USER (user_name, encrypted_user_name, email, encrypted_email, ...) VALUES (?, ?, ?, ?, ...)
```
After:
```javascript
INSERT INTO USER (encrypted_user_name, encrypted_email, ...) VALUES (?, ?, ...)
```

Before (SELECT fallback):
```javascript
if (row.encrypted_user_name) {
  row.user_name = await tableCipher.decrypt(row.encrypted_user_name);
}
```
After:
```javascript
row.user_name = await tableCipher.decrypt(row.encrypted_user_name);
delete row.encrypted_user_name;
// ... 모든 대상 컬럼에 대해 반복
```

#### 3c. 기존 컬럼 참조 제거

- SELECT 쿼리에서 **모든 기존 컬럼** 제거 (신규 암호화 컬럼만 조회)
- Pattern B: 복수 컬럼이므로 INSERT/UPDATE/SELECT에서 모든 원본 컬럼 참조 일괄 제거
- 컬럼명 변경이 필요한 경우 사용자에게 확인

#### 3d. 테스트 업데이트

fallback 테스트 케이스 제거, 암호화 컬럼 직접 사용 테스트로 교체

#### 3e. 커밋 및 PR

1. `/commit` command 패턴으로 커밋
2. `/pr-push` command 패턴으로 PR 생성:
   - 제목: `[<TICKET>] remove plaintext column from <테이블명>`
   - label: `enhancement`

#### 3f. 다음 repo 진행 전 확인

AskUserQuestion으로 선택지 제공:
- **다음 repo 진행** — 다음 의존 repo로 이동합니다
- **현재 repo 수정** — 생성된 코드를 수정합니다
- **나머지 skip** — 나머지 repo는 건너뜁니다

---

### Step 4: data-schema DDL 정리

**주의**: 이 단계는 Step 3의 모든 PR이 머지된 후에 진행해야 합니다.

AskUserQuestion으로 확인:
- **코드 정리 PR 머지 완료** — 모든 의존 repo PR이 머지되었는지
- **지금 DDL 정리 진행** vs **나중에 수동 진행**

진행하는 경우, data-schema 로컬 경로를 확인하고 없으면 clone:

```bash
DATA_SCHEMA_PATH=$(find ~/dev -maxdepth 3 -type d -name "data-schema" 2>/dev/null | head -1)
if [ -z "$DATA_SCHEMA_PATH" ]; then
  gh repo clone teamdable/data-schema /tmp/data-schema
  DATA_SCHEMA_PATH="/tmp/data-schema"
fi

cd $DATA_SCHEMA_PATH
git checkout <default-branch> && git pull
git checkout -b feature/<TICKET>/remove_plaintext_column
```

`rds/<데이터베이스(소문자)>/<테이블명>.sql`에서:
- **모든 기존 평문 컬럼** DDL 라인 제거 (columns 배열의 모든 원본 컬럼)
- 신규 암호화 컬럼은 유지

```bash
# 커밋 및 PR
git add <DDL 파일>
git commit -m "chore: remove plaintext column(s) from <테이블명>"
```

`/pr-push` command 패턴으로 PR 생성:
- 제목: `[<TICKET>] remove plaintext column(s) from <테이블명>`

---

### Step 5: JIRA 카드 완료 댓글

```bash
cat <<'EOF' | jira issue comment add <TICKET> --template -
## 암호화 마이그레이션 Phase 3 완료

### 정리 완료 항목
- [ ] 의존 repo fallback 로직 제거
- [ ] 의존 repo 이중 쓰기 제거
- [ ] data-schema 기존 컬럼 DDL 제거

### 생성된 PR
- <repo-1>: <PR URL>
- <repo-2>: <PR URL>
- data-schema: <PR URL>
EOF
```

---

### Step 6: 완료 요약

```
## 암호화 마이그레이션 전체 완료

### Phase 1 (준비): ✅
### Phase 2 (데이터 마이그레이션): ✅
### Phase 3 (정리): ✅

### 생성된 PR 목록
- <repo별 PR URL>

### 주의사항
- 기존 컬럼이 제거되므로 LIKE 검색 등에서 암호화된 필드는 매칭 불가
- 검색 기능이 있는 경우 별도 대응 필요
```
