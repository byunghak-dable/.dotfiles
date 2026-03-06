# zinit 초기화 (OS별 경로 분기)
if [[ -f /opt/homebrew/opt/zinit/zinit.zsh ]]; then
	source /opt/homebrew/opt/zinit/zinit.zsh
elif [[ -f "$HOME/.local/share/zinit/zinit.zsh" ]]; then
	source "$HOME/.local/share/zinit/zinit.zsh"
fi

# 플러그인 - turbo mode (프롬프트 후 비동기 로딩)
zinit wait lucid for \
	atinit"zicompinit; zicdreplay" \
	zsh-users/zsh-syntax-highlighting \
	atload"_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions

# pyenv - zinit로 lazy loading
zinit ice wait"0" lucid
zinit light davidparsson/zsh-pyenv-lazy

# direnv - turbo mode
zinit ice wait"0" lucid
zinit snippet OMZ::plugins/direnv/direnv.plugin.zsh
