---
allowed-tools: Bash(git branch:*), Bash(git checkout:*), Bash(git log:*), Bash(git remote:*), Bash(mkdir:*)
description: Create a git branch following project conventions
---

## Context

- Current branch: !`git branch --show-current`
- Recent branches: !`git branch --sort=-committerdate -a | grep -v HEAD | sed 's/remotes\/origin\///' | sort -u | head -20`
- Default remote branch: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | sed 's/.*: //'`
- Project branch convention: !`cat .claude/branch-convention.md 2>/dev/null || grep -A 40 -m 1 "## Branch" CLAUDE.md 2>/dev/null || echo "__USE_DEFAULT__"`

## Your Task

### Step 1: 브랜치 컨벤션 확인

"Project branch convention"이 `__USE_DEFAULT__`인 경우:

1. 위 "Recent branches" 목록을 분석하여 네이밍 패턴을 파악
2. `.claude/` 디렉토리 생성 후 `.claude/branch-convention.md` 파일을 작성
3. 이후 브랜치 생성에 해당 컨벤션 적용

### Step 2: 브랜치명 결정

사용자가 브랜치명 또는 작업 내용을 제공한 경우 → 컨벤션에 맞게 변환하여 생성
사용자가 아무것도 제공하지 않은 경우 → 어떤 작업을 위한 브랜치인지 물어보세요

### Step 3: 브랜치 생성

```bash
git checkout -b <branch-name>
```
