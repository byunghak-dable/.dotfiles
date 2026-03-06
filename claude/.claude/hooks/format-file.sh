#!/bin/bash
# PostToolUse hook: LazyVim conform.nvim과 동일한 formatter 적용
# Mason 바이너리를 우선 사용

# Mason 경로를 PATH 앞에 추가하여 우선 탐색
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

FILE_PATH=$(jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ] && exit 0

case "$FILE_PATH" in
*.js | *.jsx | *.ts | *.tsx | *.json | *.css | *.scss | *.html | *.yaml | *.yml | *.md | *.mdx | *.graphql)
	prettier --write "$FILE_PATH" 2>/dev/null
	;;
*.lua)
	stylua "$FILE_PATH" 2>/dev/null
	;;
*.go)
	gofmt -w "$FILE_PATH" 2>/dev/null
	;;
*.java)
	google-java-format --replace "$FILE_PATH" 2>/dev/null
	;;
*.py)
	ruff format "$FILE_PATH" 2>/dev/null
	;;
*.rs)
	rustfmt "$FILE_PATH" 2>/dev/null
	;;
*.c | *.cpp | *.h | *.hpp)
	clang-format -i "$FILE_PATH" 2>/dev/null
	;;
*.kt | *.kts)
	ktlint --format "$FILE_PATH" 2>/dev/null
	;;
*.toml)
	taplo fmt "$FILE_PATH" 2>/dev/null
	;;
*.sh | *.bash | *.zsh)
	shfmt -w "$FILE_PATH" 2>/dev/null
	;;
esac

exit 0
