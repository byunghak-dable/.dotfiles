---
name: plan
disable-model-invocation: true
allowed-tools: Read, Grep, Glob
description: planner 에이전트로 구현 계획 수립
argument-hint: <구현할 기능 또는 작업 설명>
---

# Plan

This command invokes the **planner** agent to create actionable work plans.

## 사용 시점

- 복잡한 기능 구현 전
- 아키텍처 변경 전
- 대규모 리팩토링 전 (3파일 이상 변경 예상 시 필수)
- 요구사항이 불명확할 때

## 작동 방식

planner agent (opus)가 다음을 수행한다:

1. **요구사항 인터뷰**: $ARGUMENTS 분석, 불명확한 점은 사용자에게 질문
2. **코드베이스 탐색**: Glob/Grep/Read로 관련 코드, 기존 패턴, 의존성 파악
3. **계획 수립**: 3-6개의 구체적 단계, 각 단계에 acceptance criteria 포함
4. **결과물**: 실행 가능한 work plan

## 핵심 원칙

- **계획만 수립, 구현 안 함** — planner는 코드를 작성하지 않는다
- **3-6 단계** — 30개 미세 단계도, 2개 모호한 지시도 아닌
- **코드베이스 사실은 직접 조사** — 사용자에게 묻지 않고 Grep/Read로 확인
- **각 단계에 acceptance criteria** — 완료 조건이 명확해야 함

## 출력 형식

```
## Plan: <작업 제목>

### 배경
[왜 이 작업이 필요한가]

### 단계

1. **<단계 제목>**
   - 작업: <구체적 행동>
   - 대상 파일: <file:line>
   - 완료 조건: <검증 가능한 기준>

2. ...

### 의존성
[단계 간 순서 제약]

### 리스크
[주의할 점, 영향 범위]
```

## 사용 예시

```
/plan 결제 모듈에 환불 기능 추가
/plan 인증을 JWT에서 세션 기반으로 전환
/plan API 응답 캐싱 레이어 추가
```

## Related Agent

This command invokes the `planner` agent located at:
`~/.claude/agents/planner.md`

---

## 다음 단계

| 계획이 끝나면    | 커맨드       |
| :--------------- | :----------- |
| 테스트 주도 개발 | `/tdd`       |
| 아키텍처 분석    | `/architect` |
