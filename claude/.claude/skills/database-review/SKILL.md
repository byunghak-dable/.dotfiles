---
name: database-review
model: opus
allowed-tools: Read, Grep, Glob, Bash(psql:*), Bash(git diff:*), Bash(git log:*), Agent
description: SQL 쿼리 최적화, 스키마 설계, RLS 정책, 마이그레이션 리뷰. Use when DB 관련 코드 작성 또는 변경 시.
argument-hint:
  [파일 경로 또는 --schema|--query|--security - 생략 시 변경된 SQL 파일 대상]
---

# Database Review

This command invokes the **database-reviewer** agent for SQL and schema audits.

## Step 1: 범위 결정

| $ARGUMENTS   | 동작                              |
| :----------- | :-------------------------------- |
| 파일 경로    | 해당 파일만 리뷰                  |
| `--schema`   | 스키마 전체 리뷰                  |
| `--query`    | 쿼리 성능만 리뷰                  |
| `--security` | RLS/권한만 리뷰                   |
| 생략         | `git diff`에서 SQL 변경 파일 대상 |

1. $ARGUMENTS 파싱하여 리뷰 범위 결정
2. `git diff --name-only` — SQL 관련 변경 파일 목록
3. 프로젝트 타입 감지

## Step 2: database-reviewer 서브에이전트 호출

Agent tool (subagent_type: general-purpose, model: opus)로 호출:

```
당신은 database-reviewer 에이전트입니다.
~/.claude/agents/database-reviewer.md의 지침을 따르세요.

리뷰 범위: [Step 1에서 결정된 범위]
변경 파일: [git diff 결과 또는 지정 파일]

수행할 검토:
- 쿼리 리뷰: WHERE/JOIN 인덱스 확인, N+1 패턴 탐지, EXPLAIN ANALYZE
- 스키마 리뷰: 데이터 타입, 제약조건, 네이밍 컨벤션
- 보안 리뷰: RLS 정책, 권한 설정, (SELECT auth.uid()) 패턴

Never Approve 체크리스트:
- int for IDs → bigint 필수
- varchar(255) without reason → text 사용
- timestamp without timezone → timestamptz 필수
- float for money → numeric 필수
- RLS per-row 함수 호출 → (SELECT auth.uid()) 패턴
- GRANT ALL → least privilege

severity별 이슈 + SQL 수정 예시 포함하여 보고
```

## Step 3: 결과 출력

서브에이전트의 DB 리뷰 보고서를 사용자에게 전달한다.

---

## 다음 단계

| 리뷰가 끝나면  | 커맨드           |
| :------------- | :--------------- |
| 수정 사항 검증 | `/verify-loop`   |
| 코드 리뷰      | `/review-staged` |
