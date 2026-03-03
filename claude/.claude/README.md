# Claude Code Configuration

[Claude Code](https://docs.anthropic.com/en/docs/claude-code) 글로벌 설정입니다. 모든 프로젝트에 공통 적용됩니다.

## Setup

```sh
cd ~/.dotfiles
stow claude   # ~/.claude → symlink
```

## Directory Structure

```
.claude/
├── CLAUDE.md                  # 글로벌 행동 규칙 (Claude가 항상 읽음)
├── settings.json              # 권한, hooks, 모델 설정
├── commands/                  # 슬래시 커맨드 (/commit, /branch, ...)
├── agents/                    # 서브에이전트 정의 (code-reviewer, architect, ...)
├── hooks/                     # Pre/PostToolUse hook 스크립트
├── rules/                     # 언어/도메인별 코딩 규칙
└── skills/                    # 자동 트리거 스킬
```

## Quick Start

```sh
# 1. symlink 생성
cd ~/.dotfiles && stow claude

# 2. 아무 프로젝트에서 Claude Code 실행
cd ~/my-project && claude

# 3. 슬래시 커맨드 사용
/commit          # 변경 사항 커밋
/branch feat/xxx # 브랜치 생성
/pr-push         # PR 생성
```

## Commands (슬래시 커맨드)

Claude Code 채팅에서 `/`로 호출합니다.

### Git Workflow

| 커맨드           | 설명                                                     |
| ---------------- | -------------------------------------------------------- |
| `/commit`        | 변경 사항을 관심사별로 분리, 리뷰 후 커밋                |
| `/branch`        | 프로젝트 컨벤션에 맞는 브랜치 생성 (기본 separator: `_`) |
| `/review-staged` | staged 변경 사항 4관점 리뷰 (버그, 컨벤션, 보안, 설계)   |

### PR Workflow

| 커맨드              | 설명                                                         |
| ------------------- | ------------------------------------------------------------ |
| `/pr-push`          | 브랜치 리뷰 → push → PR 생성/업데이트 (assignee, label 자동) |
| `/pr-review-branch` | PR 생성 전 브랜치 변경 사항 리뷰                             |
| `/pr-review`        | PR 코드 품질 심층 리뷰                                       |
| `/pr-analyze`       | PR 변경점 구조 분석 (목적, 핵심 변경, 데이터 흐름)           |

### Utility

| 커맨드              | 설명                                      |
| ------------------- | ----------------------------------------- |
| `/resume-session`   | 이전 세션 히스토리에서 관련 컨텍스트 검색 |
| `/analyze-insights` | Insights 분석 결과와 설정 간 gap 보고     |

## Agents (서브에이전트)

Claude가 복잡한 작업 시 별도 컨텍스트에서 전문 에이전트를 실행합니다.

**분석/설계 (읽기 전용)**

| Agent       | 용도                                 | 호출 시점                     |
| ----------- | ------------------------------------ | ----------------------------- |
| `architect` | 아키텍처 분석, 디버깅 근본 원인 진단 | 설계 결정, 대규모 리팩토링 전 |
| `planner`   | 작업 계획 수립, 단계별 분해          | 복잡한 기능 구현 전           |

**리뷰**

| Agent               | 용도                                 | 호출 시점                |
| ------------------- | ------------------------------------ | ------------------------ |
| `code-reviewer`     | 2단계 리뷰 (스펙 준수 → 코드 품질)   | 코드 수정 후             |
| `security-reviewer` | OWASP Top 10 기반 보안 취약점 분석   | 인증/API/DB 코드 수정 후 |
| `database-reviewer` | 스키마, 쿼리, RLS, 마이그레이션 리뷰 | DB 관련 코드 수정 후     |

**실행/수정**

| Agent                  | 용도                        | 호출 시점                |
| ---------------------- | --------------------------- | ------------------------ |
| `build-error-resolver` | 빌드 에러 분석 및 자동 수정 | 빌드 실패 시             |
| `refactor-cleaner`     | 코드 정리, 리팩토링         | 리팩토링 작업 시         |
| `doc-updater`          | API 문서, README 업데이트   | 기능 변경 후 문서 동기화 |

**검증**

| Agent          | 용도                                       | 호출 시점              |
| -------------- | ------------------------------------------ | ---------------------- |
| `verify-agent` | 빌드 → 타입체크 → 린트 → 테스트 파이프라인 | 구현 완료 후 최종 검증 |
| `tdd-guide`    | TDD 사이클 가이드                          | 테스트 주도 개발 시    |
| `e2e-runner`   | E2E 테스트 실행 및 결과 분석               | 통합 테스트 필요 시    |

## Hooks (자동 실행)

도구 실행 전후에 자동으로 동작합니다. 별도 호출이 필요 없습니다.

### 동작 흐름

```
[사용자 요청]
  → Claude가 도구 실행 결정
  → PreToolUse hook 검사 (Bash인 경우 remote-command-guard)
    → 차단: exit 2 → 실행 거부
    → 허용: exit 0 → 도구 실행
  → 도구 실행 완료
  → PostToolUse hooks 순차 실행:
    1. output-secret-filter (모든 도구) → 시크릿 마스킹
    2. format-file (Edit/Write) → 포매터 실행
    3. security-auto-trigger (Edit/Write) → 보안 파일 수정 감지
    4. code-quality-reminder (Edit/Write) → 품질 체크 리마인더
```

### Hook 목록

| Hook                    | 트리거            | 동작                                    |
| ----------------------- | ----------------- | --------------------------------------- |
| `remote-command-guard`  | Bash 실행 전      | 위험 명령 7개 카테고리 차단             |
| `output-secret-filter`  | 모든 도구 실행 후 | API 키, 토큰 등 시크릿 자동 마스킹      |
| `format-file`           | 파일 수정 후      | 프로젝트 포매터 자동 실행               |
| `security-auto-trigger` | 파일 수정 후      | 보안 관련 파일 수정 감지 시 리뷰 권고   |
| `code-quality-reminder` | 코드 파일 수정 후 | 에러 핸들링, 불변성, 입력 검증 리마인더 |

### remote-command-guard 차단 카테고리

1. **파괴적 삭제** — `rm -rf`, `mkfs`, `dd`
2. **시크릿 유출** — `env`, `printenv`, `echo $SECRET_*`, `cat .env`
3. **경로 순회** — `/etc/passwd`, `/proc/self/`, `../../etc/`
4. **외부 통신** — `curl`, `wget`, `nc`, `ssh`, `scp` (localhost 제외)
5. **권한 변경** — `chmod 777`, `chown`, `sudo`, `mount`
6. **프로세스 종료** — `kill -9`, `pkill`, `shutdown`, `reboot`
7. **명령 주입** — `eval`, `exec`, `| sh`, `base64 -d | bash`

### output-secret-filter 감지 패턴

- API 키: OpenAI(`sk-`), AWS(`AKIA`), GitHub(`ghp_`), GitLab(`glpat-`), Slack(`xoxb-`), NPM(`npm_`)
- 인증 토큰: Bearer, token=, auth=, api_key=
- 환경변수 값: `AWS_SECRET_ACCESS_KEY=`, `OPENAI_API_KEY=` 등
- Private Key 블록
- Base64/URL 인코딩으로 우회된 시크릿

마스킹 발생 시 `~/.claude/security.log`에 기록됩니다 (값 자체는 기록하지 않음).

### security-auto-trigger 감지 패턴

아래 패턴이 포함된 파일을 수정하면 보안 리뷰를 권고합니다 (세션당 파일별 1회):

`auth`, `login`, `session`, `token`, `jwt`, `oauth`, `credential`, `permission`, `middleware`, `.env`, `security`, `rls`, `policy`, `migration`, `route`, `api/`, `encrypt`, `decrypt`, `hash`, `crypto`

## Permission 모델

```
허용 (Bash(*), Read(*), Edit(*), ...)
  ↓ deny 규칙으로 위험 명령 차단
  ↓ PreToolUse hook으로 2차 검증
  = 안전한 명령만 실행
```

### 자동 차단되는 명령 (deny 규칙)

| 카테고리                 | 예시                                        |
| ------------------------ | ------------------------------------------- |
| 파괴적 삭제              | `rm -rf /`, `rm -rf ~`, `rm -rf .`          |
| 권한 상승                | `sudo`, `chmod 777`                         |
| 외부 스크립트 실행       | `curl \| sh`, `wget \| sh`                  |
| Force push (main/master) | `git push --force main`                     |
| 패키지 배포              | `npm publish`, `pnpm publish`               |
| 코드 실행 주입           | `eval`, `bash -c`, `node -e`, `osascript`   |
| 시스템 설정 변경         | `crontab`, `launchctl`, `~/.zshrc` 덮어쓰기 |

## Rules (코딩 규칙)

Claude가 코드를 작성/수정할 때 자동 적용되는 규칙입니다.

| 파일                  | 내용                                                          |
| --------------------- | ------------------------------------------------------------- |
| `code-principles.md`  | fail-fast, 불필요한 Optional 금지, 접근 제어, Stepdown Rule   |
| `typescript.md`       | destructuring 우선, 중괄호 필수, 모듈 시스템 유지             |
| `python.md`           | namespace packages, `@property` 접근 제어, name mangling 규칙 |
| `database.md`         | MySQL DDL 제약 사항                                           |
| `date-calculation.md` | 날짜 계산 시 `date`/`python3` 필수 사용, 암산 금지            |

## Skills (자동 트리거)

특정 작업 패턴을 감지하면 Claude가 자동으로 활성화합니다.

| Skill                  | 트리거 조건                              |
| ---------------------- | ---------------------------------------- |
| `large-scale-rename`   | 2-3개 파일 이상에 걸친 심볼 이름 변경    |
| `mermaid-architecture` | 아키텍처/흐름 다이어그램 작성 요청       |
| `python-oop-review`    | Python 코드 작성/리뷰 시 OOP 컨벤션 검사 |

## CLAUDE.md 행동 규칙

| 규칙                | 설명                                                                          |
| ------------------- | ----------------------------------------------------------------------------- |
| 파일 지정 편집      | 사용자가 특정 파일을 명시하면 해당 파일만 읽고 수정. 관련 없는 파일 탐색 금지 |
| Commands 우선       | 재사용 가능한 workflow는 skill이 아닌 `~/.claude/commands/` command로 작성    |
| 세션 종료 작업 요약 | 요청 시 auto memory에 작업 상태(완료/미완료/핵심 파일) 기록                   |

## 커스터마이징

### 커맨드 추가

`commands/` 디렉토리에 `.md` 파일을 추가하면 `/파일명`으로 호출할 수 있습니다.

```markdown
---
allowed-tools: Read, Bash(git diff:*)
description: 커맨드 설명
---

프롬프트 내용을 여기에 작성합니다.
```

### 규칙 추가

`rules/` 디렉토리에 `.md` 파일을 추가하면 Claude가 자동으로 읽고 적용합니다.

### 권한 수정

`settings.json`의 `permissions.allow`/`permissions.deny` 배열을 수정합니다. deny 규칙이 allow보다 우선합니다.
