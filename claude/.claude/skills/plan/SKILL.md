---
name: plan
allowed-tools: Read, Grep, Glob
description: planner 에이전트로 구현 계획 수립
argument-hint: <구현할 기능 또는 작업 설명>
---

# Plan

This command invokes the **planner** agent to create actionable work plans.

> **참고**: 3파일 이상 변경 예상 시 필수. 요구사항이 불명확할 때도 사용.

## Step 1: 컨텍스트 수집

1. 프로젝트 타입 감지: `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`
2. CLAUDE.md 읽기 (있으면) — 프로젝트 규칙/패턴 파악
3. `git diff --name-only` — 현재 작업 상태 파악

## Step 2: planner 서브에이전트 호출

Agent tool (subagent_type: general-purpose, model: opus)로 호출:

```
당신은 planner 에이전트입니다.
~/.claude/agents/planner.md의 지침을 따르세요.

프로젝트 타입: [감지된 타입]
작업 요청: $ARGUMENTS

핵심 원칙:
- 계획만 수립, 구현 안 함 — 코드를 작성하지 않는다
- 3-6 단계 — 30개 미세 단계도, 2개 모호한 지시도 아닌
- 코드베이스 사실은 직접 조사 — 사용자에게 묻지 않고 Grep/Read로 확인
- 각 단계에 acceptance criteria — 완료 조건이 명확해야 함
- 사용자에게는 선호도/우선순위만 AskUserQuestion으로 질문

출력 형식:
  ## Plan: <작업 제목>
  ### 배경 — 왜 이 작업이 필요한가
  ### 단계 — 각 단계에 작업/대상 파일(file:line)/완료 조건
  ### 의존성 — 단계 간 순서 제약
  ### 리스크 — 주의할 점, 영향 범위
```

## Step 3: 결과 처리

서브에이전트의 계획을 사용자에게 전달하고 승인을 기다린다.

---

## 다음 단계

| 계획이 끝나면    | 커맨드       |
| :--------------- | :----------- |
| 테스트 주도 개발 | `/tdd`       |
| 아키텍처 분석    | `/architect` |
