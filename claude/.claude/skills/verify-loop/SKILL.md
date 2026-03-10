---
name: verify-loop
model: sonnet
allowed-tools: Bash(npm:*), Bash(npx:*), Bash(python:*), Bash(go:*), Bash(cargo:*), Bash(make:*), Bash(git:*), Bash(rm:*), Read, Edit, Grep, Glob, Agent
description: verify-agent 서브에이전트로 fresh-context 자동 검증 (verification-engine 통합)
argument-hint: "[의도 설명] [--max-retries N] [--only build|test|lint] [--security] [--coverage]"
---

# Verify Loop

This command invokes the **verify-agent** via Agent tool (fresh-context subagent) for unbiased verification.

## 0단계: 설정 파싱

- `--max-retries N`: 최대 재시도 횟수 (기본: 3)
- `--only [type]`: 특정 검증만 실행 (build|test|lint|typecheck)
- 나머지: 의도 설명

## 1단계: 초기 환경 수집

1. `git status --short` — 변경사항 확인 (없으면 중단)
2. `git diff --name-only` — 변경 파일 목록
3. Read: `.claude/handoff.md` (있으면)
4. Read: `CLAUDE.md`, `spec.md`, `prompt_plan.md` (있는 것만)
5. 프로젝트 타입 감지:
   - `package.json` → Node.js (npm/pnpm/yarn)
   - `Cargo.toml` → Rust
   - `go.mod` → Go
   - `pyproject.toml` → Python

## 2단계: 의도 파악

- handoff.md 있으면 → handoff.md 기반
- $ARGUMENTS에 의도 있으면 → $ARGUMENTS 기반
- 둘 다 없으면 → 안내 후 중단:

  ```
  ⚠️ 의도를 알 수 없습니다.
  /verify-loop "변경 의도 설명"으로 재시도하세요.
  ```

## 3단계: verify-agent 서브에이전트 호출

Agent tool (subagent_type: general-purpose, model: sonnet)로 호출:

```
당신은 verify-agent입니다.
~/.claude/agents/verify-agent.md의 지침을 따르세요.

프로젝트 타입: [감지된 타입]
패키지 매니저: [감지된 PM]
변경 파일: [git diff --name-only 결과]
의도: [2단계에서 파악한 의도]

검증 모드: loop (최대 [N]회 재시도)
검증 범위: [--only 값 또는 all]

순서: TypeCheck → Lint → Build → Test
- Fixable 에러 (import 누락, 린트 포맷, 미사용 변수, 단순 타입 오류)는 자동 수정 후 재검증
- Non-fixable 에러 (로직 오류, 아키텍처 이슈)는 목록으로 보고
- 최대 수정 파일 10개/라운드
- 수정 후 반드시 빌드 재실행으로 검증

최종 결과를 다음 형식으로 보고:
  ├── TypeCheck: ✅/❌
  ├── Lint: ✅/❌
  ├── Build: ✅/❌
  └── Test: ✅/❌
  상태: PASS/FAIL
  수정 내역: [파일:변경 요약]
  미해결: [에러 목록]
```

## 4단계: 결과 처리

**PASS:**

1. `rm .claude/handoff.md` (있으면)
2. 안내:

```
✅ Verification 완료 (성공)

다음 단계: /commit 또는 /pr-push
```

**FAIL:**

```
❌ Verification 실패

미해결 에러:
  1. [파일:라인] - [에러 메시지]
  2. ...

권장 조치:
  - 에러 수동 수정 후 /verify-loop 재실행
  - 아키텍처 문제라면 /architect로 분석
```

## 추가 모드 (verification-engine 통합)

### --security 모드

`/verify-loop --security "의도"` — 보안 검증 포함. security-pipeline 스킬과 연동.

### --coverage 모드

`/verify-loop --coverage "의도"` — 테스트 커버리지 분석 포함.
서브에이전트에 추가 지시: "테스트 커버리지를 측정하고 80% 미만 파일을 보고하세요."

### Fixable Auto-Repair (서브에이전트 내부)

| 유형            | 감지 패턴                | 수정 방법                   |
| --------------- | ------------------------ | --------------------------- |
| Missing Import  | `Cannot find module`     | import 문 추가              |
| Unused Import   | `defined but never used` | import 행 제거              |
| Lint (auto-fix) | eslint fixable           | `eslint --fix`              |
| Type Mismatch   | `not assignable`         | 타입 캐스팅/인터페이스 수정 |
| Formatting      | prettier/gofmt           | 포매터 실행                 |

Non-fixable (로직 오류, 아키텍처 이슈)는 보고만 하고 수정하지 않음.
