ZDOTDIR=$HOME/.config/zsh

# --- setttings ---
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/plugins.zsh

# PATH 설정 (eval 없이 직접 추가)
[[ -d $HOME/.volta/bin ]] && export VOLTA_HOME="$HOME/.volta" && export PATH="$VOLTA_HOME/bin:$PATH"
[[ -d $HOME/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d $HOME/.local/share/bob/nvim-bin ]] && export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
[[ -d $HOME/.sdkman/candidates/java/current/bin ]] && export PATH="$HOME/.sdkman/candidates/java/current/bin:$PATH"

# pyenv PATH (초기화는 zinit에서 lazy loading)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT ]] && export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# go PATH lazy loading
if (( $+commands[go] )); then
  __go_lazy_init() {
    unfunction go 2>/dev/null
    export PATH="$(command go env GOPATH)/bin:$PATH"
  }
  go() { __go_lazy_init && command go "$@" }
fi

# --- bash word select ---
autoload -U select-word-style
select-word-style bash

# --- completion ---
zmodload zsh/complist
zstyle ':completion:*' menu select
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# --- history ---
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=$HOME/.cache/.zsh_history
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- config for os ---
case "$(uname -s)" in
Darwin) # mac
  export XDG_CONFIG_HOME=$HOME/.config
  alias brew86="arch -x86_64 /usr/local/bin/brew"
  alias pyenv86="arch -x86_64 pyenv"
  alias ls="ls -G"
  alias ll="ls -lGFh"
  alias la="ls -laGFh"
	;;
Linux) # linux
  alias ls='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -al --color=auto'
	;;
esac

# --- fzf ---
export FZF_DEFAULT_OPTS="--layout reverse"
export FZF_DEFAULT_COMMAND='fd --type f'

# --- custom ----
export PYTHON_ENV=${PYTHON_ENV}; 
export PYTHONPATH=${REPO_PATH}:$PYTHONPATH;

