# Claude Code 커스터마이징 가이드 — 설계 문서

## 개요

### 목적

개인 `.claude/` 설정을 팀에 공유하고, 팀 공통으로 적용할 Agents/Skills를 제안하는 문서를 작성한다.

### 대상 독자

- CLAUDE.md, settings.json 설정 경험이 있는 중급 사용자
- 기본 개념보다 실전 활용 패턴에 비중

### 산출물

- Markdown 문서 1개 → 리뷰 후 Notion 업로드
- 문서 구조는 "가이드(따라하기)" + "제안(논의)" 이중 구조

---

## 문서 구조

### 1. 개요 [가이드]

- 이 문서의 목적: 개인 설정 공유 + 팀 공통 적용 제안
- 대상 독자 명시

### 2. 설정 구조 가이드 [가이드]

#### 2.1 기반: .claude/ 디렉토리 구조 + settings.json

- `.claude/` 디렉토리 트리 overview
- settings.json 주요 필드: permissions, env, hooks, plugins
- 글로벌(~/.claude/) vs 프로젝트(.claude/) 설정 우선순위

#### 2.2 실행 체계

**Agents**

- 개념: 특정 역할에 특화된 sub-agent (전용 tools, model, 프롬프트)
- 작성법: `.claude/agents/<name>.md` frontmatter 구조
- 호출 방식: Agent tool의 `subagent_type` 또는 skill에서 dispatch

**Agent Teams**

- 전제조건: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"`
- 구조: Leader(조율만, 직접 구현 금지) + Teammates(최대 3명, 실제 구현)
- 핵심 원칙: 파일 소유권 분리 (같은 파일 동시 편집 → 덮어쓰기 방지)
- 역할 템플릿: 풀스택(FE/BE/QA), 리팩토링(Analyzer/Implementer/Verifier), 버그 조사
- Task 배정: 팀원당 5-6개, 의존성은 `addBlockedBy`로 관리

**Skills**

- 개념: 재사용 가능한 workflow 레시피 (오케스트레이터)
- 작성법: `.claude/skills/<name>/SKILL.md` frontmatter 구조
- 두 가지 호출 방식:
  - auto-trigger: 모델이 맥락에 따라 자동 호출
  - 명시적 호출: `/skill-name` 슬래시 커맨드 (`disable-model-invocation: true`)

**Skill ↔ Agent 관계**

- Skill = 무엇을 어떤 순서로 (오케스트레이션)
- Agent = 특정 역할에 집중 (전문 실행)
- Agent는 독립 호출도 가능하고, 여러 Skill에서 재사용됨
- 예시: `work-post` skill → code-reviewer, security-reviewer, verify-agent, database-reviewer 병렬 dispatch

#### 2.3 자동화 장치: Hooks

- 개념: Claude가 tool을 사용할 때 전후로 자동 실행되는 shell script
- 종류:
  - PreToolUse: tool 실행 전 (차단/수정 가능)
  - PostToolUse: tool 실행 후 (출력 처리/알림)
- 작성법: settings.json의 `hooks` 필드 + `.claude/hooks/<name>.sh`
- exit code 규약: 0 = 허용, 2 = 차단

---

### 3. 내 설정 소개 [가이드]

#### 전체 구성

- 7 Agents, 18 Skills, 6 Hooks, 5 Rules, 14 Plugins

#### 설계 철학

- 다층 안전장치: hooks(자동 가드) → agents(전문 검증) → skills(워크플로우)
- 병렬 실행: Agent Teams로 독립 작업 동시 처리
- 토큰 효율: RTK proxy로 60-90% 절감

#### 개인용 하이라이트

- `obsidian`: 개인 노트 연동
- `session-wrap`: 세션 종료 시 4개 subagent 병렬 실행 (doc-updater, automation-scout, learning-extractor, followup-suggester)

---

### 4. 팀 적용 제안 [제안]

#### 추천 Agents (7개)

| Agent             | 역할                                        | 호출되는 Skill              |
| ----------------- | ------------------------------------------- | --------------------------- |
| architect         | 아키텍처 분석, 디버깅 근본 원인 진단        | work-pre                    |
| planner           | 작업 분해, step-by-step 계획 수립           | work-pre                    |
| code-reviewer     | 2단계 체계적 코드 리뷰 (spec 준수 → 품질)   | work-post, github-pr-review |
| security-reviewer | OWASP Top 10 보안 취약점 분석               | work-post                   |
| database-reviewer | 스키마, 쿼리, RLS, 마이그레이션 리뷰        | work-post (DB 변경 시)      |
| refactor-cleaner  | dead code 제거, 코드 정리                   | work-clean                  |
| verify-agent      | 빌드 → 타입 → 린트 → 테스트 검증 파이프라인 | work-post                   |

#### 추천 Skills (16개)

**dable-\* (4개)** — 사내 도구 연동

| Skill               | 용도                                         |
| ------------------- | -------------------------------------------- |
| dable-encrypt       | DB 컬럼 암호화 마이그레이션 3단계 워크플로우 |
| dable-jira-create   | JIRA 이슈 생성                               |
| dable-jira-summary  | 브랜치 작업 내용을 JIRA 코멘트로 요약        |
| dable-sprint-report | 스프린트 리포트 생성                         |

**git-\* (2개)** — Git 워크플로우

| Skill      | 용도                                      |
| ---------- | ----------------------------------------- |
| git-branch | 프로젝트 컨벤션에 맞는 브랜치 생성        |
| git-commit | 관심사별 분리, staged diff 리뷰 포함 커밋 |

**github-\* (4개)** — GitHub 연동

| Skill             | 용도                                                              |
| ----------------- | ----------------------------------------------------------------- |
| github-pr-push    | 브랜치 리뷰 → push → PR 생성/업데이트                             |
| github-pr-analyze | PR 변경 구조 분석                                                 |
| github-pr-review  | 5개 관점 병렬 PR 리뷰 (버그, 컨벤션, 설계, 보안, 테스트 커버리지) |
| github-pr-respond | PR 리뷰 코멘트 순차 반영 + 답변 게시                              |

**work-\* (6개)** — 구현 파이프라인

| Skill              | 용도                                 | 단계 |
| ------------------ | ------------------------------------ | ---- |
| work-brainstorming | 요구사항 탐색 + spec 작성            | 기획 |
| work-pre           | 코드베이스 분석 + 실행 계획          | 계획 |
| work               | Agent Teams 병렬 구현                | 실행 |
| work-post          | 코드 품질/빌드/보안/DB 병렬 검증     | 검증 |
| work-fix           | 빌드/타입/린트/테스트 에러 자동 수정 | 수정 |
| work-clean         | dead code, 미사용 import/변수 정리   | 정리 |

#### 프로젝트 repo 적용 방법

- 프로젝트 루트에 `.claude/` 디렉토리 생성
- agents/, skills/ 복사 또는 symlink
- settings.json은 프로젝트별로 override 가능
- `.gitignore`에 개인 설정 제외 패턴 추가
- 주의: hooks 경로가 절대경로를 포함할 수 있으므로, 팀 공유 시 `~` 또는 상대경로로 통일 필요

#### 논의 포인트

- Rules (code-principles.md, 언어별 conventions): 팀 합의 후 적용 여부 결정
- Hooks: 팀 공통 필요 여부 별도 논의

---

### 5. 시현 시나리오 가이드 [가이드 + 제안]

#### 시나리오 A: 기능 구현 full cycle

**흐름:**

```
/work-brainstorming "기능 설명"
  → spec + plan 생성
/work-pre
  → 코드베이스 분석 + 실행 계획
/work
  → Agent Teams 구성 (FE/BE/QA)
  → 병렬 구현 + Task 관리
/work-post
  → code-reviewer + security-reviewer + verify-agent + database-reviewer 병렬 검증
/git-commit
  → 관심사별 커밋 분리
/github-pr-push
  → PR 생성 + assignee/labels 자동 추론
```

**사전 준비물:**

- 간단한 기능 요구사항 (예: API 엔드포인트 추가)
- 빌드/테스트 가능한 프로젝트

**보여줄 포인트:**

- Agent Teams의 Leader-Teammate 상호작용
- 파일 소유권 분리가 실제로 동작하는 모습
- work-post의 병렬 검증 결과 리포트
- git-commit의 관심사별 분리

#### 시나리오 B: PR 리뷰 cycle

**흐름:**

```
/github-pr-review <PR 번호>
  → 5개 에이전트 병렬 리뷰 (버그, 컨벤션, 설계, 보안, 테스트 커버리지)
  → 종합 리포트
/github-pr-respond
  → 리뷰 코멘트별 반영 여부 확인
  → 코드 수정 + 답변 게시
```

**사전 준비물:**

- 리뷰할 PR (리뷰 코멘트가 달린 상태면 시나리오 B가 더 풍부)

**보여줄 포인트:**

- 5개 관점의 병렬 리뷰가 각각 어떤 이슈를 잡는지
- 리뷰 코멘트에 대한 자동 반영 + 답변 흐름

---

## 제약사항

- 문서는 Markdown으로 작성, Notion 구조는 업로드 시 결정
- Rules는 이 문서에서 제안하지 않음 (별도 논의 대상)
- 시현은 문서에 가이드만 포함, 실제 데모는 라이브로 진행
