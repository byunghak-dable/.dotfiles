---
name: build-fix
model: sonnet
allowed-tools: Bash(npm:*), Bash(npx:*), Bash(pnpm:*), Bash(yarn:*), Bash(go:*), Bash(cargo:*), Bash(make:*), Bash(git diff:*), Read, Edit, Write, Grep, Glob, Agent
description: build-error-resolver 에이전트로 빌드 에러 자동 수정
argument-hint: [빌드 커맨드 - 생략 시 자동 감지]
---

# Build and Fix

> **참고**: 빌드 에러가 아키텍처 문제에서 기인하는 경우, `/plan`으로 구조적 해결 방안을 먼저 수립하세요.

This command invokes the **build-error-resolver** agent to fix build errors with minimal changes.

## Step 1: 환경 감지

1. 프로젝트 매니페스트 확인:
   - `package.json` → TypeScript/Node (npm/pnpm/yarn)
   - `Cargo.toml` → Rust
   - `go.mod` → Go
   - `pyproject.toml` → Python
2. 빌드 커맨드 결정:
   - $ARGUMENTS에 명시된 경우 → 해당 커맨드 사용
   - 없으면 → `package.json`의 `build` 스크립트 또는 언어별 기본 커맨드
3. 변경 파일 목록: `git diff --name-only`

## Step 2: build-error-resolver 서브에이전트 호출

Agent tool (subagent_type: general-purpose, model: sonnet)로 호출:

```
당신은 build-error-resolver 에이전트입니다.
~/.claude/agents/build-error-resolver.md의 지침을 따르세요.

프로젝트 타입: [감지된 타입]
빌드 커맨드: [감지된 커맨드]
변경 파일: [git diff 결과]

빌드 에러를 최소 변경으로 수정하세요.
- 리팩토링 금지, 에러 수정만
- 변경량은 영향 파일 크기의 5% 이내
- 수정 후 반드시 빌드 재실행으로 검증
```

## Step 3: 결과 처리

- **빌드 성공** → 수정 요약 출력
- **빌드 실패** → 미해결 에러 목록 + 권장 조치 안내

---

## 다음 단계

| 빌드 수정이 끝나면 | 커맨드           |
| :----------------- | :--------------- |
| 전체 검증          | `/verify-loop`   |
| 코드 리뷰          | `/review-staged` |
