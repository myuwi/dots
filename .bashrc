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
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias cal='cal -mw'
alias yt-dl='yt-dlp'
alias pn='pnpm'
alias lg='lazygit'

[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
