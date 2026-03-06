---
name: tdd
allowed-tools: Bash(npm:*), Bash(npx:*), Bash(pnpm:*), Bash(yarn:*), Bash(go:*), Bash(cargo:*), Bash(python:*), Bash(git diff:*), Read, Write, Edit, Grep, Glob, Agent
description: 테스트 먼저 만들고 코드 작성. 한 단위 작업에 사용.
argument-hint: <구현할 기능 설명>
---

# TDD Command

This command invokes the **tdd-guide** agent to enforce test-driven development methodology.

> **참고**: 3개 이상 파일이 변경될 예상이라면 `/plan`을 먼저 실행하세요.

## Step 1: 환경 감지

1. 프로젝트 매니페스트 확인: `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`
2. 테스트 프레임워크 감지: jest, vitest, playwright, pytest 등
3. `git diff --name-only` — 현재 변경 파일 확인
4. 기존 테스트 패턴 파악: `Glob("**/*.test.*")` 또는 `Glob("**/*.spec.*")`

## Step 2: tdd-guide 서브에이전트 호출

Agent tool (subagent_type: general-purpose, model: sonnet)로 호출:

```
당신은 tdd-guide 에이전트입니다.
~/.claude/agents/tdd-guide.md의 지침을 따르세요.

프로젝트 타입: [감지된 타입]
테스트 프레임워크: [감지된 프레임워크]
기존 테스트 패턴: [감지된 패턴]
구현 요청: $ARGUMENTS

TDD 사이클을 엄격히 따르세요:
1. RED: 실패하는 테스트 작성 → 실행하여 실패 확인
2. GREEN: 최소한의 코드로 테스트 통과
3. REFACTOR: 코드 정리, 테스트 여전히 통과 확인

요구사항:
- 테스트를 먼저 작성한 후에 구현 코드 작성
- 각 TDD 사이클에서 반드시 테스트 실행하여 결과 확인
- 80%+ 커버리지 목표
- 기존 테스트 패턴(프레임워크, 네이밍, 구조) 일관성 유지
- 외부 의존성은 mock 처리
```

## Step 3: 결과 처리

- **테스트 통과** → TDD 리포트 출력 (사이클 수, 커버리지, 작성된 테스트 파일)
- **테스트 실패** → 미해결 에러 목록 + 권장 조치

---

## 다음 단계

| 구현이 끝나면    | 커맨드           |
| :--------------- | :--------------- |
| 빌드/테스트 검증 | `/verify-loop`   |
| 코드 리뷰        | `/review-staged` |
