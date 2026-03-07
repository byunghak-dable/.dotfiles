---
name: post-impl-check
allowed-tools: Bash(npm:*), Bash(npx:*), Bash(pnpm:*), Bash(git:*), Bash(go:*), Bash(cargo:*), Bash(make:*), Read, Grep, Glob, Agent
description: 구현 후 3개 에이전트 병렬 검증 (코드 리뷰 + 빌드/테스트 + 보안)
argument-hint: [의도 설명 - 생략 시 git diff 기반 추론]
---

# Post-Implementation Check

구현 완료 후 **3개 에이전트를 병렬로** 실행하여 품질을 종합 검증합니다.

## Step 1: 환경 수집

1. `git diff --name-only` — 변경 파일 목록 (없으면 중단)
2. `git diff --stat` — 변경 규모 파악
3. 프로젝트 타입 감지: `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`
4. CLAUDE.md 읽기 (있으면)

## Step 2: 3개 서브에이전트 병렬 호출

다음 3개 Agent tool 호출을 **동시에** 실행:

### Agent A: code-reviewer (코드 품질)

Agent tool (subagent_type: general-purpose, model: opus):

```
당신은 code-reviewer 에이전트입니다.
~/.claude/agents/code-reviewer.md의 지침을 따르세요.

변경 파일: [git diff --name-only 결과]
CLAUDE.md 규칙: [CLAUDE.md 내용]

변경된 코드를 리뷰하세요:
- CLAUDE.md 규칙 준수 여부
- 로직 오류, edge case, null/undefined
- 설계 적합성, 레이어 위반

발견한 이슈를 severity(critical/major/minor)와 file:line으로 보고
```

### Agent B: verify-agent (빌드/테스트)

Agent tool (subagent_type: general-purpose, model: opus):

```
당신은 verify-agent입니다.
~/.claude/agents/verify-agent.md의 지침을 따르세요.

프로젝트 타입: [감지된 타입]
변경 파일: [git diff --name-only 결과]
의도: $ARGUMENTS

검증 모드: single-pass (재시도 없음, 상태만 보고)
순서: TypeCheck → Lint → Build → Test

최종 결과를 다음 형식으로 보고:
  ├── TypeCheck: ✅/❌
  ├── Lint: ✅/❌
  ├── Build: ✅/❌
  └── Test: ✅/❌
  상태: PASS/FAIL
```

### Agent C: security-reviewer (보안)

Agent tool (subagent_type: general-purpose, model: opus):

```
당신은 security-reviewer 에이전트입니다.
~/.claude/agents/security-reviewer.md의 지침을 따르세요.

변경 파일: [git diff --name-only 결과]

변경된 파일만 대상으로 빠른 보안 스캔:
- 하드코딩된 secrets
- Injection 취약점 (SQL, XSS, Command)
- 인증/인가 우회 가능성

CRITICAL/HIGH 이슈만 보고 (MEDIUM 이하 생략)
```

## Step 3: 결과 종합

3개 에이전트 결과를 합산하여 출력:

```
## Post-Implementation Check

### 빌드/테스트
├── TypeCheck: ✅/❌
├── Lint: ✅/❌
├── Build: ✅/❌
└── Test: ✅/❌

### 코드 리뷰
- [severity] 이슈 N건

### 보안
- [severity] 이슈 N건

### 종합 판정: PASS / NEEDS ATTENTION / FAIL
```

| 판정            | 조건                                  |
| :-------------- | :------------------------------------ |
| PASS            | 빌드 통과 + critical 이슈 0건         |
| NEEDS ATTENTION | 빌드 통과 + major/minor 이슈 있음     |
| FAIL            | 빌드 실패 또는 critical 이슈 1건 이상 |

---

## 다음 단계

| 결과에 따라  | 커맨드         |
| :----------- | :------------- |
| 빌드 실패    | `/build-fix`   |
| 이슈 수정 후 | `/verify-loop` |
| 모두 통과    | `/commit`      |
