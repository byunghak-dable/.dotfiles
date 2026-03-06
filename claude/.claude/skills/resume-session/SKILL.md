---
name: resume-session
disable-model-invocation: true
allowed-tools: Bash(rg *), Bash(ls *), Bash(jq *)
description: Search previous session history for related context
---

## Context

- Working directory: !`pwd`
- Projects dir: ~/.claude/projects

## jq filter

```
select(.type == "user" or .type == "assistant")
| .message | select(.content | not | not) | .role as $role
| (if (.content | type) == "array" then [.content[] | select(.type? == "text") | .text] | join(" ") else .content end) as $text
| select($text | test("KEYWORD_PATTERN"; "i"))
| select($text | test("system-reminder|local-command") | not)
| "[\($proj):\($sid)] [\($role)] \($text[0:200])"
```

## Your Task

사용자 요청에서 핵심 키워드를 추출하고 세션 히스토리를 검색하세요.

### 1. 현재 프로젝트 검색

Claude Code는 프로젝트 경로의 `/`와 `.`을 `-`로 치환하여 디렉토리명을 생성한다.

```bash
rg -i "keyword1|keyword2" --glob "*.jsonl" --sortr modified -l \
  ~/.claude/projects/$(echo "<working_directory>" | tr '/.' '-') \
  | head -5 \
  | while read -r f; do
      proj=$(basename "$(dirname "$f")" | grep -oE '[^-]+$')
      sid=$(basename "$f" | cut -c1-8)
      jq -r --arg proj "$proj" --arg sid "$sid" '<jq_filter>' "$f" 2>/dev/null
    done | head -10
```

### 2. 결과별 처리

- **매치 있음**: 발췌 결과를 보여주고 AskUserQuestion으로 선택지 제공:
  - **이어서 진행** — 해당 컨텍스트를 기반으로 작업을 이어갑니다
  - **다시 검색** — 다른 키워드로 재검색합니다
- **매치 없음**: 검색 범위를 `~/.claude/projects/` 전체로 확장하여 재검색
