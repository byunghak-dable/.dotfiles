---
allowed-tools: Bash(npx:*), Bash(npm:*), Bash(pnpm:*), Bash(git:*), Read, Write, Edit, Grep, Glob
description: e2e-runner 에이전트로 Playwright E2E 테스트 생성/실행
argument-hint: <테스트 대상 사용자 흐름 설명>
---

# E2E Test

This command invokes the **e2e-runner** agent for end-to-end testing with Playwright.

## 사용 시점

- 핵심 사용자 흐름 검증 (로그인, 결제, 가입 등)
- 새 기능의 통합 테스트
- 기존 E2E 테스트 유지보수
- Flaky 테스트 안정화

## 작동 방식

e2e-runner agent (sonnet)가 다음을 수행한다:

1. **테스트 대상 파악**: $ARGUMENTS에서 사용자 흐름 식별
2. **테스트 생성/수정**: Playwright 기반 E2E 테스트 작성
3. **테스트 실행**: `npx playwright test` 실행
4. **Artifact 관리**: 스크린샷, 비디오, trace 수집
5. **Flaky 테스트 처리**: 불안정한 테스트 격리 및 안정화

## 핵심 원칙

- **Critical flows first** — 매출/인증에 영향 있는 흐름 우선
- **Semantic selectors** — `data-testid`, `role`, `label` 우선 (CSS selector 지양)
- **독립적 테스트** — 각 테스트는 다른 테스트에 의존하지 않음
- **Retry with trace** — 실패 시 trace 첨부하여 디버깅 용이하게

## 사용 예시

```
/e2e 사용자 로그인 → 대시보드 → 프로필 수정 흐름 테스트
/e2e 결제 프로세스 전체 E2E 테스트 작성
/e2e 기존 auth.spec.ts가 flaky한데 안정화해줘
```

## Related Agent

This command invokes the `e2e-runner` agent located at:
`~/.claude/agents/e2e-runner.md`

---

## 다음 단계

| 테스트가 끝나면 | 커맨드           |
| :-------------- | :--------------- |
| 전체 검증       | `/verify-loop`   |
| 코드 리뷰       | `/review-staged` |
