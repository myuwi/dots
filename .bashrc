#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /usr/share/nvm/init-nvm.sh

source /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM='auto'

PS1='\[$(tput setaf 4)\]\w$(__git_ps1 " \[$(tput setaf 7)\]\[$(tput setaf 2)\]%s") \[$(tput setaf 4)\]>\[$(tput sgr0)\] '

export EDITOR=nvim
export HISTCONTROL=ignoreboth

alias ls='ls -A --color=auto'
alias ll='\ls -lhA --color=auto --group-directories-first'
alias mv='mv -i'
alias rm='rm -i'
alias ..='cd ..'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias please='sudo $(history -p !!)'
alias cal='cal -mw'

export BFETCH_INFO="mfetch"
export BFETCH_ART="mfetch art"
export BFETCH_CLASSIC_MODE=true
