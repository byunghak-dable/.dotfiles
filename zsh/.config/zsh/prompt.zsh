#!/bin/sh
# antigen init $ZDOTDIR/.antigenrc
autoload -Uz vcs_info
autoload -U colors && colors

# setup git
zstyle ':vcs_info:*' enable git 
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats "%{${fg[blue]}%}(%{${fg[red]}%}%m%u%c%{${fg[yellow]}%}%{${fg[magenta]}%} %b%{${fg[blue]}%})"

PROMPT="%B%{${fg[cyan]}%}%c\$vcs_info_msg_0_ %(?:%{${fg_bold[green]}%}:%{${fg_bold[red]}%}) "
