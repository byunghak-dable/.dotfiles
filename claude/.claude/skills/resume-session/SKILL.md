---
name: resume-session
description: Use when user wants to explore or resume previous session history. Triggers on '/resume', '이전 세션', '세션 히스토리', '이전에 ~했던', 'previous session', or references to past work in current project.
---

# Resume Session

## Overview

이전 Claude Code 세션 히스토리를 탐색하여 관련 컨텍스트를 현재 대화에 요약 보고한다.
**컨텍스트 최소화 원칙**: 스니펫 최대 300자, 발췌 최대 3개, 탐색 세션 최대 5개.

## Process

### Step 1: 키워드 추출

사용자 요청에서 핵심 키워드를 추출한다.
예: "이전에 k8s 권한 문제 어떻게 했지?" → `['k8s', '권한', 'rollout', 'permission', 'rbac']`

### Step 2: 프로젝트 세션 디렉토리 특정

현재 cwd를 기반으로 프로젝트 디렉토리를 특정한다.

```bash
python3 -c "
import os
cwd = os.getcwd()
project_key = cwd.replace('/', '-').replace('_', '-')
print(os.path.expanduser(f'~/.claude/projects/{project_key}'))
"
```

다른 프로젝트를 사용자가 명시한 경우, `~/.claude/projects/` 내에서 해당 이름이 포함된 디렉토리를 찾는다:

```bash
ls ~/.claude/projects/ | grep <project-name>
```

### Step 3: 키워드 검색 및 발췌

최근 5개 세션에서 키워드 매치 결과를 추출한다.

```bash
python3 << 'EOF'
import json, glob, os
from datetime import datetime

PROJECT_DIR = "<Step 2에서 얻은 경로>"
KEYWORDS = [<Step 1에서 추출한 키워드>]  # 모두 소문자

files = sorted(glob.glob(f'{PROJECT_DIR}/*.jsonl'), key=os.path.getmtime, reverse=True)[:5]
results = []

for f in files:
    mtime = os.path.getmtime(f)
    fname = os.path.basename(f)[:8]
    try:
        with open(f) as fp:
            for line in fp:
                try:
                    entry = json.loads(line)
                    if entry.get('type') not in ('user', 'assistant'):
                        continue
                    msg = entry.get('message', {})
                    role = msg.get('role', '')
                    content = msg.get('content', '')
                    texts = []
                    if isinstance(content, list):
                        for c in content:
                            if isinstance(c, dict) and c.get('type') == 'text':
                                texts.append(c['text'])
                    elif isinstance(content, str):
                        texts.append(content)
                    for text in texts:
                        if any(kw in text.lower() for kw in KEYWORDS):
                            if text.strip().startswith('<local-command') or text.strip().startswith('<system'):
                                continue
                            results.append((mtime, fname, role, text[:300]))
                            if len(results) >= 3:
                                break
                except:
                    pass
        if len(results) >= 3:
            break
    except:
        pass

for mtime, fname, role, text in results:
    dt = datetime.fromtimestamp(mtime).strftime('%Y-%m-%d')
    print(f'[{dt} / {fname}] [{role}]')
    print(text.strip())
    print('---')

if not results:
    print("NO_MATCH")
EOF
```

### Step 4: 결과 보고

**매치 있는 경우**: 발췌 결과를 아래 형식으로 보고 후, 이어서 진행할지 사용자에게 확인한다.

```
[날짜 / 세션ID] [role]
발췌 내용 (300자 이하)
---
```

**NO_MATCH인 경우 (폴백)**: 최근 3개 세션의 user 메시지 첫 줄만 나열한다.

```bash
python3 << 'EOF'
import json, glob, os
from datetime import datetime

PROJECT_DIR = "<Step 2에서 얻은 경로>"
files = sorted(glob.glob(f'{PROJECT_DIR}/*.jsonl'), key=os.path.getmtime, reverse=True)[:3]

for f in files:
    dt = datetime.fromtimestamp(os.path.getmtime(f)).strftime('%Y-%m-%d %H:%M')
    print(f'\n[{dt}]')
    try:
        with open(f) as fp:
            for line in fp:
                try:
                    entry = json.loads(line)
                    if entry.get('type') != 'user':
                        continue
                    msg = entry.get('message', {})
                    content = msg.get('content', '')
                    text = ''
                    if isinstance(content, list):
                        for c in content:
                            if isinstance(c, dict) and c.get('type') == 'text' and c['text'].strip():
                                text = c['text']
                                break
                    elif isinstance(content, str):
                        text = content
                    if text.strip() and not text.strip().startswith('<'):
                        print(f'  - {text.strip()[:100]}')
                        break
                except:
                    pass
    except:
        pass
EOF
```
