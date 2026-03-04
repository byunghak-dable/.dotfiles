---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Read, Glob, Grep
description: Insights 분석 결과를 Claude Code 설정과 대조하여 실제 gap을 찾아 보고
---

## 전제 조건

이 command는 `/insights` 실행 후 같은 세션에서 실행해야 합니다.
대화 컨텍스트에 insights JSON 데이터(`claude_md_additions`, `features_to_try`, `usage_patterns`, `friction_analysis`)가 있어야 합니다.
없으면 사용자에게 `/insights`를 먼저 실행하라고 안내하고 중단하세요.

## Step 1: 현재 설정 수집

아래 모든 설정을 병렬로 읽으세요. 존재하지 않는 파일은 건너뛰세요.

### Global 설정

| 대상                             | 경로                                    |
| -------------------------------- | --------------------------------------- |
| CLAUDE.md                        | `~/.claude/CLAUDE.md`                   |
| Rules                            | `~/.dotfiles/claude/.claude/rules/*.md` |
| Commands                         | `~/.claude/commands/*.md`               |
| Settings (hooks, enabledPlugins) | `~/.claude/settings.json`               |

### Project 설정

| 대상      | 경로                      |
| --------- | ------------------------- |
| CLAUDE.md | `./CLAUDE.md`             |
| Rules     | `./.claude/rules/*.md`    |
| Commands  | `./.claude/commands/*.md` |
| Settings  | `./.claude/settings.json` |

### Memory

프로젝트 키는 현재 working directory의 절대 경로에서 `/`와 `.`을 `-`로 치환한 값입니다.

| 대상        | 경로                                        |
| ----------- | ------------------------------------------- |
| Auto memory | `~/.claude/projects/<project-key>/memory/*` |

### Plugins & Skills

| 대상               | 출처                                          |
| ------------------ | --------------------------------------------- |
| Enabled plugins    | `~/.claude/settings.json` → `enabledPlugins`  |
| 사용 가능한 skills | 이 세션의 system-reminder에 나열된 skill 목록 |

## Step 2: Insights 제안 추출

대화 컨텍스트의 insights JSON에서 다음 섹션의 제안을 모두 추출하세요:

- `suggestions.claude_md_additions` — CLAUDE.md에 추가할 규칙 제안
- `suggestions.features_to_try` — 시도할 기능 제안
- `suggestions.usage_patterns` — 사용 패턴 개선 제안
- `friction_analysis.categories` — friction 패턴 (참고용)

## Step 3: 대조 분석

각 제안을 Step 1에서 수집한 **모든 설정과 의미 기반으로** 대조하세요.

판단 기준:

- **이미 있음**: 해당 규칙/기능이 설정에 명시되어 있거나, command/skill이 동일한 역할을 수행
- **부분 커버**: 관련 규칙이 있으나 제안의 특정 케이스를 명시적으로 다루지 않음
- **누락**: 어떤 설정에서도 커버되지 않음

**중요**: CLAUDE.md만 보지 마세요. commands, rules, hooks, plugins, skills, memory 모두 대조하세요.

## Step 4: 결과 출력

```markdown
## Insights 제안 vs 현재 설정 대조

| #   | Insights 제안 | 커버하는 설정        | 상태      |
| --- | ------------- | -------------------- | --------- |
| 1   | <제안 요약>   | <설정 파일명 + 위치> | 이미 있음 |
| 2   | <제안 요약>   | <부분 커버하는 설정> | 부분 커버 |
| 3   | <제안 요약>   | 없음                 | 누락      |

## 실제 Gap (N건)

### 1. <누락된 제안 제목>

- **Insights 근거**: <friction 데이터 또는 제안 이유>
- **적용 위치**: <어떤 설정 파일의 어떤 섹션>
- **제안 내용**: `<추가할 규칙 또는 설정>`
```

- "이미 있음" 항목은 테이블에만 포함하고 상세 설명은 생략
- "부분 커버"와 "누락" 항목만 Gap 섹션에 상세 기술
- Gap이 없으면 "모든 제안이 현재 설정에서 커버되고 있습니다"로 마무리

## Step 5: 사용자 승인 대기

Gap 보고 후 AskUserQuestion으로 선택지를 제공하세요:

- **모두 적용** — 모든 gap 항목을 설정 파일에 적용합니다
- **선택 적용** — 적용할 항목을 골라서 반영합니다 (multiSelect)
- **적용 안 함** — 보고만 확인하고 종료합니다
