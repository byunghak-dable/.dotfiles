---
name: refactor-clean
allowed-tools: Bash(npm:*), Bash(npx:*), Bash(pnpm:*), Bash(git:*), Read, Edit, Write, Grep, Glob, Agent
description: refactor-cleaner 에이전트로 dead code 제거 및 코드 정리
---

# Refactor Clean

> **참고**: 대규모 리팩토링(3파일 이상 변경 예상)은 `/plan`을 먼저 실행하세요.

This command invokes the **refactor-cleaner** agent for safe dead code removal and cleanup.

## 작동 방식

refactor-cleaner agent (sonnet)가 다음을 수행한다:

1. **Dead code 탐지**: knip, depcheck, ts-prune 등 분석 도구 실행
2. **분류**: severity별 카테고리화
   - SAFE: 테스트 파일, 미사용 유틸리티
   - CAUTION: API 라우트, 컴포넌트
   - DANGER: 설정 파일, 메인 엔트리포인트
3. **안전한 삭제만 제안**: DANGER는 건드리지 않음
4. **삭제 전 검증**: 테스트 실행 → 삭제 → 재테스트 → 실패 시 롤백
5. **삭제 기록**: 제거된 코드의 요약 문서화

## 핵심 원칙

- **When in doubt, don't remove** — 안전 우선
- 삭제 전 반드시 테스트 실행
- 한 번에 하나의 파일/export만 삭제
- 번들 크기, 빌드 시간 영향 추적

## Related Agent

This command invokes the `refactor-cleaner` agent located at:
`~/.claude/agents/refactor-cleaner.md`

---

## 다음 단계

| 리팩토링이 끝나면 | 커맨드           |
| :---------------- | :--------------- |
| 코드 리뷰         | `/review-staged` |
| 전체 검증         | `/verify-loop`   |
