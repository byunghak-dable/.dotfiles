#!/bin/zsh
# Obsidian second-brain 유틸 함수
SECOND_BRAIN="$HOME/second-brain"

# 오늘 inbox에 빠른 메모 추가
function note() {
  local file="$SECOND_BRAIN/00-inbox/$(date +%Y-%m-%d).md"
  [[ ! -f "$file" ]] && echo "# Quick Notes - $(date +%Y-%m-%d)\n" > "$file"
  echo "- $(date +%H:%M) $*" >> "$file"
  echo "✓ $file"
}

# 학습 큐에 항목 추가
function learn() {
  local queue="$SECOND_BRAIN/02-learning/queue.md"
  echo "- [ ] $(date +%Y-%m-%d) $*" >> "$queue"
  echo "✓ 학습 큐 추가: $*"
}
