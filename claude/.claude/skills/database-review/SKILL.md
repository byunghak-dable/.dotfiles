---
name: database-review
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(psql:*), Bash(git diff:*), Bash(git log:*)
description: database-reviewer 에이전트로 SQL/스키마/RLS 리뷰
argument-hint:
  [파일 경로 또는 --schema|--query|--security - 생략 시 변경된 SQL 파일 대상]
---

# Database Review

This command invokes the **database-reviewer** agent for SQL and schema audits.

## 사용 시점

- SQL 쿼리 작성/수정 후
- 마이그레이션 파일 작성 후
- 스키마 설계 검토
- 성능 이슈 진단

## 작동 방식

database-reviewer agent가 다음을 수행한다:

1. **범위 결정**: $ARGUMENTS 또는 `git diff`에서 SQL 관련 파일 식별
2. **쿼리 리뷰**: WHERE/JOIN 인덱스 확인, N+1 패턴 탐지, EXPLAIN ANALYZE
3. **스키마 리뷰**: 데이터 타입, 제약조건, 네이밍 컨벤션
4. **보안 리뷰**: RLS 정책, 권한 설정, `(SELECT auth.uid())` 패턴
5. **결과 출력**: severity별 이슈 + SQL 수정 예시

## 리뷰 범위

| $ARGUMENTS   | 동작                              |
| :----------- | :-------------------------------- |
| 파일 경로    | 해당 파일만 리뷰                  |
| `--schema`   | 스키마 전체 리뷰                  |
| `--query`    | 쿼리 성능만 리뷰                  |
| `--security` | RLS/권한만 리뷰                   |
| 생략         | `git diff`에서 SQL 변경 파일 대상 |

## 핵심 체크리스트 (Never Approve)

- `int` for IDs → `bigint` 필수
- `varchar(255)` without reason → `text` 사용
- `timestamp` without timezone → `timestamptz` 필수
- `float` for money → `numeric` 필수
- RLS policy에서 per-row 함수 호출 → `(SELECT auth.uid())` 패턴
- `GRANT ALL` to application users → least privilege

## 사용 예시

```
/database-review supabase/migrations/20260304_orders.sql
/database-review --schema
/database-review --security
/database-review 결제 테이블의 쿼리 성능이 느린데 원인을 찾아줘
```

## Related Agent

This command invokes the `database-reviewer` agent located at:
`~/.claude/agents/database-reviewer.md`

---

## 다음 단계

| 리뷰가 끝나면  | 커맨드           |
| :------------- | :--------------- |
| 수정 사항 검증 | `/verify-loop`   |
| 코드 리뷰      | `/review-staged` |
