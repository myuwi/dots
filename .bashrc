#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR='nvim'
export VISUAL='nvim'
export HISTCONTROL=ignoreboth

alias c='clear'
alias ls='eza -a --group-directories-first'
alias ll='eza -la --group-directories-first'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias cal='cal -mw'
alias yt-dl='yt-dlp'
alias pn='pnpm'
alias lg='lazygit'
alias sxiv='nsxiv'

if command -v starship &>/dev/null; then
	eval "$(starship init bash)"
else
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWSTASHSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
	GIT_PS1_SHOWUPSTREAM='auto'
	source /usr/share/git/completion/git-prompt.sh

	red=$(tput setaf 1)
	yellow=$(tput setaf 3)
	blue=$(tput setaf 4)
	magenta=$(tput setaf 5)
	white=$(tput setaf 7)
	normal=$(tput sgr0)

	PS1='\[$yellow\]\W$(__git_ps1 " \[$white\]on \[$magenta\]%s") \[$red\]>\[$normal\] '
fi

[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
