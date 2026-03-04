---
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*), Bash(npm audit:*), Bash(npx:*)
description: security-reviewer 에이전트로 보안 취약점 분석 (OWASP Top 10)
argument-hint: [파일 경로 또는 --full - 생략 시 변경된 파일 대상]
---

# Security Review

This command invokes the **security-reviewer** agent for vulnerability detection.

## 사용 시점

- 사용자 입력 처리 코드 작성 후
- 인증/인가 로직 변경 후
- API 엔드포인트 추가/수정 후
- 민감 데이터 처리 코드 작성 후
- 배포 전 최종 점검

## 작동 방식

security-reviewer agent (opus)가 다음을 수행한다:

1. **범위 결정**: $ARGUMENTS 또는 `git diff`에서 변경 파일 식별
2. **OWASP Top 10 분석**: Injection, Broken Auth, XSS, SSRF 등
3. **Secrets 탐지**: 하드코딩된 credentials, API 키, 토큰
4. **입력 검증 리뷰**: 사용자 입력의 validation/sanitization
5. **의존성 보안**: `npm audit`, 알려진 취약점
6. **결과 출력**: severity × exploitability × blast radius 우선순위

## 리뷰 범위

| $ARGUMENTS | 동작                          |
| :--------- | :---------------------------- |
| 파일 경로  | 해당 파일만 리뷰              |
| `--full`   | 프로젝트 전체 보안 감사       |
| 생략       | `git diff`에서 변경 파일 대상 |

## 핵심 체크리스트 (CRITICAL)

- SQL/NoSQL injection
- XSS (reflected, stored, DOM-based)
- 하드코딩된 secrets
- 인증 우회 경로
- Path traversal
- CSRF 보호 누락
- 권한 상승 가능성

## Related Agent

This command invokes the `security-reviewer` agent located at:
`~/.claude/agents/security-reviewer.md`

---

## 다음 단계

| 리뷰가 끝나면  | 커맨드           |
| :------------- | :--------------- |
| 수정 사항 검증 | `/verify-loop`   |
| 코드 리뷰      | `/review-staged` |
