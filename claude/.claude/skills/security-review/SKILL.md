---
name: security-review
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*), Bash(npm audit:*), Bash(npx:*), Agent
description: security-reviewer 에이전트로 보안 취약점 분석 (OWASP Top 10)
argument-hint: [파일 경로 또는 --full - 생략 시 변경된 파일 대상]
---

# Security Review

This command invokes the **security-reviewer** agent for vulnerability detection.

## Step 1: 범위 결정

| $ARGUMENTS | 동작                          |
| :--------- | :---------------------------- |
| 파일 경로  | 해당 파일만 리뷰              |
| `--full`   | 프로젝트 전체 보안 감사       |
| 생략       | `git diff`에서 변경 파일 대상 |

1. $ARGUMENTS 파싱하여 리뷰 범위 결정
2. `git diff --name-only` — 변경 파일 목록
3. 프로젝트 타입 감지: `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`

## Step 2: security-reviewer 서브에이전트 호출

Agent tool (subagent_type: general-purpose, model: opus)로 호출:

```
당신은 security-reviewer 에이전트입니다.
~/.claude/agents/security-reviewer.md의 지침을 따르세요.

프로젝트 타입: [감지된 타입]
리뷰 범위: [Step 1에서 결정된 범위]
변경 파일: [git diff 결과 또는 지정 파일]

OWASP Top 10 전체 카테고리를 평가하세요:
- Injection, Broken Auth, XSS, SSRF, Path Traversal, CSRF, 권한 상승
- 하드코딩된 secrets 탐지 (api_key, password, secret, token)
- 의존성 보안 감사 (npm audit 등)

우선순위: severity × exploitability × blast radius
각 발견에: location(file:line), category, severity, remediation(secure code 예시) 포함
```

## Step 3: 결과 출력

서브에이전트의 보안 리뷰 보고서를 사용자에게 전달한다.

---

## 다음 단계

| 리뷰가 끝나면  | 커맨드           |
| :------------- | :--------------- |
| 수정 사항 검증 | `/verify-loop`   |
| 코드 리뷰      | `/review-staged` |
