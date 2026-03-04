---
allowed-tools: Read, Grep, Glob, Bash(git log:*), Bash(git blame:*)
description: architect 에이전트로 코드베이스 분석 및 아키텍처 진단
argument-hint: <분석 요청 - 구조 분석, 근본 원인 진단, 영향도 분석 등>
---

# Architect

This command invokes the **architect** agent for codebase analysis and architectural diagnosis.

## 사용 시점

- 새 기능 설계 전 구조 분석
- 디버깅 시 근본 원인 진단
- 대규모 리팩토링 전 영향도 분석
- 아키텍처 결정이 필요할 때

## 작동 방식

architect agent가 다음을 수행한다:

1. **컨텍스트 수집**: Glob/Grep/Read로 프로젝트 구조 파악 (병렬 실행)
2. **가설 수립**: 수집된 정보에서 패턴과 문제점 식별
3. **교차 검증**: 가설을 실제 코드(file:line)와 대조
4. **진단 종합**: Summary → Analysis → Root Cause → Recommendations → Trade-offs

## 핵심 원칙

- **READ-ONLY**: 코드를 읽기만 하고 절대 수정하지 않는다
- **Evidence-based**: 모든 발견에 `file:line` 참조 필수
- **Trade-offs 명시**: 모든 권장사항에 장단점을 함께 제시
- **Concrete**: "리팩토링을 고려하세요" ❌ → "`auth.ts:42-80`의 validation 로직을 분리" ✅

## 출력 형식

```
## Summary
[1-2문장 요약]

## Analysis
[코드 기반 분석, file:line 참조 포함]

## Root Cause
[증상이 아닌 근본 원인]

## Recommendations
1. [구체적 행동 + 대상 파일/라인]
2. ...

## Trade-offs
[각 권장사항의 장단점]

## References
[분석에 사용된 파일 목록]
```

## 사용 예시

```
/architect 인증 모듈의 세션 관리가 왜 메모리 누수를 일으키는지 분석해줘
/architect 결제 모듈을 마이크로서비스로 분리할 때 영향도 분석
/architect 현재 DB 접근 패턴의 N+1 문제를 진단해줘
```

## Related Agent

This command invokes the `architect` agent located at:
`~/.claude/agents/architect.md`

---

## 다음 단계

| 분석이 끝나면    | 커맨드  |
| :--------------- | :------ |
| 구현 계획 수립   | `/plan` |
| 테스트 주도 개발 | `/tdd`  |
