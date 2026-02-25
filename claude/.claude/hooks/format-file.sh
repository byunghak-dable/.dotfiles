#!/bin/bash
# PostToolUse hook: LazyVim conform.nvim과 동일한 formatter 적용
# formatter 미설치 시 설치 명령어 제안

FILE_PATH=$(jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ] && exit 0

# OS 패키지 매니저 감지
detect_pkg_cmd() {
  local pkg="$1"
  if command -v brew &>/dev/null; then
    echo "brew install $pkg"
  elif command -v apt-get &>/dev/null; then
    echo "sudo apt-get install $pkg"
  elif command -v dnf &>/dev/null; then
    echo "sudo dnf install $pkg"
  elif command -v pacman &>/dev/null; then
    echo "sudo pacman -S $pkg"
  else
    return 1
  fi
}

suggest_install() {
  local name="$1" native="$2" pkg_name="${3:-$1}"
  local msg="[format-hook] '$name' not found. Install: $native"
  local pkg_cmd
  if pkg_cmd=$(detect_pkg_cmd "$pkg_name"); then
    msg="$msg (or: $pkg_cmd)"
  fi
  echo "$msg"
}

case "$FILE_PATH" in
*.js | *.jsx | *.ts | *.tsx | *.json | *.css | *.scss | *.html | *.yaml | *.yml | *.md | *.mdx | *.graphql)
  if command -v prettier &>/dev/null; then
    prettier --write "$FILE_PATH" 2>/dev/null
  else
    suggest_install "prettier" "npm i -g prettier"
  fi
  ;;
*.lua)
  if command -v stylua &>/dev/null; then
    stylua "$FILE_PATH" 2>/dev/null
  else
    suggest_install "stylua" "cargo install stylua" "stylua"
  fi
  ;;
*.go)
  if command -v gofmt &>/dev/null; then
    gofmt -w "$FILE_PATH" 2>/dev/null
  else
    suggest_install "gofmt" "https://go.dev/dl/" "go"
  fi
  ;;
*.java)
  if command -v google-java-format &>/dev/null; then
    google-java-format --replace "$FILE_PATH" 2>/dev/null
  else
    suggest_install "google-java-format" "https://github.com/google/google-java-format/releases" "google-java-format"
  fi
  ;;
*.py)
  if command -v ruff &>/dev/null; then
    ruff format "$FILE_PATH" 2>/dev/null
  elif command -v black &>/dev/null; then
    black --quiet "$FILE_PATH" 2>/dev/null
  else
    suggest_install "ruff" "pip install ruff" "ruff"
  fi
  ;;
*.sh | *.bash | *.zsh)
  if command -v shfmt &>/dev/null; then
    shfmt -w "$FILE_PATH" 2>/dev/null
  else
    suggest_install "shfmt" "go install mvdan.cc/sh/v3/cmd/shfmt@latest" "shfmt"
  fi
  ;;
esac

exit 0
