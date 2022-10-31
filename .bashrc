#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM='auto'

red=$(tput setaf 1)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
white=$(tput setaf 7)
normal=$(tput sgr0)

PS1='\[$yellow\]\W$(__git_ps1 " \[$white\]on \[$magenta\]%s") \[$red\]>\[$normal\] '

export EDITOR=nvim
export HISTCONTROL=ignoreboth

alias ls='exa -a --group-directories-first'
alias ll='exa -la --group-directories-first'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ..='cd ..'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias please='sudo $(history -p !!)'
alias cal='cal -mw'
alias yt-dl='yt-dlp'

export BFETCH_INFO="mfetch"
export BFETCH_ART="mfetch art"
export BFETCH_CLASSIC_MODE=true
