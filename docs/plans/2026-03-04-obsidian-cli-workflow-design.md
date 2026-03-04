# Obsidian CLI + Claude Code 워크플로우 설계

- **날짜**: 2026-03-04
- **접근법**: A. Global Rule + Commands
- **CLI**: yakitrak/obsidian-cli (Obsidian 앱 독립)
- **Vault**: `~/second-brain`

## 요구사항

- Claude Code에서 obsidian-cli로 vault 조작 (어디서든)
- 자연어 + slash command 둘 다 지원
- 용도: 노트 정리/자동화, 리서치 → 노트, 학습/지식 관리

## 파일 구조

```
dotfiles/claude/.claude/
├── rules/
│   └── obsidian.md              # [NEW] obsidian-cli 글로벌 룰
└── commands/
    ├── obsidian-note.md         # [NEW] 스마트 노트 생성
    ├── obsidian-organize.md     # [NEW] 노트 정리
    ├── obsidian-research.md     # [NEW] 리서치 → 노트
    └── obsidian-learn.md        # [NEW] 학습 큐 관리
```

stow로 `claude` 모듈이 관리되므로 추가 설정 불필요.

## 1. Global Rule (`rules/obsidian.md`)

매 세션 자동 로드. obsidian-cli 레퍼런스 + vault 구조.

내용:

- obsidian-cli 핵심 명령어 테이블
- vault 폴더 구조 (00-inbox, 02-learning 등)
- 노트 작성 규칙 (frontmatter, wikilink)
- vault 경로 (`~/second-brain`)

## 2. Commands

### `/obsidian-note` — 스마트 노트 생성

- $ARGUMENTS에서 주제/내용 파악
- obsidian-cli search-content로 기존 관련 노트 검색
- 중복이면 기존 노트에 append, 새로우면 create
- frontmatter 자동 생성 (date, tags)
- 관련 노트에 wikilink 추가

### `/obsidian-organize` — 노트 정리

- 00-inbox/ 내 노트 스캔
- 적절한 폴더로 이동 제안 (사용자 확인 후 실행)
- 누락된 태그/backlink 추가
- frontmatter 정규화

### `/obsidian-research` — 리서치 → 노트 저장

- $ARGUMENTS의 주제를 웹 검색
- 기존 관련 노트 확인
- 구조화된 마크다운 노트 생성
- 관련 기존 노트에 wikilink 연결

### `/obsidian-learn` — 학습 관리

- $ARGUMENTS 없으면: queue.md 현황 보여주기
- $ARGUMENTS 있으면: 큐 추가 or 학습 노트 생성
- 완료 항목 체크, 학습 노트로 전환

## 3. 기존 스크립트와 역할 분리

|           | 쉘 스크립트 (scripts/)  | Claude command          |
| --------- | ----------------------- | ----------------------- |
| 속도      | 즉시 (단순 append)      | 수초 (AI 분석)          |
| 지능      | 고정 경로에 텍스트 추가 | 검색, 중복 확인, 구조화 |
| 사용 환경 | 터미널 어디서든         | Claude Code 세션 내     |

## 4. setup.sh

변경 없음. 기존 obsidian-cli 기본 vault 등록 로직 + stow 관리로 충분.
