# Agent prompt 템플릿: fallback 제거 (Step 3)

```
## 작업 개요
<TICKET> 암호화 마이그레이션 Phase 3 — <repo-name>에서 평문 컬럼 fallback 제거

## 대상 정보
(Step 문서의 대상 정보 전체를 복사)

## 작업 범위
- repo 경로: <repo-path>
- 대상 파일: <파일 목록>

## 작업 절차

### 1. 브랜치 생성
cd <repo-path>
git checkout <default-branch> && git pull
git checkout -b feature/<TICKET>/remove_plaintext_column

### 2. fallback 로직 제거

**Pattern B:**
- INSERT 이중 쓰기 제거: 원본 컬럼 제거, encrypted_* 만 유지
- UPDATE 이중 쓰기 제거: 원본 SET 제거, encrypted_* SET만 유지
- SELECT fallback 제거:
  Before: if (row.encrypted_xxx) { decrypt } (fallback)
  After: row.xxx = await decrypt(row.encrypted_xxx); delete row.encrypted_xxx;

**Pattern A:**
- INSERT 이중 쓰기 제거: 원본 컬럼 제거, partially_encrypted_* 만 유지
- SELECT fallback 제거: if 분기 없이 항상 partially_encrypted 에서 복호화

### 3. 기존 컬럼 참조 제거
- SELECT 쿼리에서 원본 컬럼 제거
- 컬럼명 변경이 필요한 경우 사용자에게 확인

### 4. 테스트 업데이트
fallback 테스트 케이스 제거, 암호화 컬럼 직접 사용 테스트로 교체

### 5. 커밋 및 PR
- git push -u origin feature/<TICKET>/remove_plaintext_column
- gh pr create --title "WIP: [<TICKET>] remove plaintext column from <테이블명>" --assignee @me
- **PR URL을 반드시 결과에 포함**
```
