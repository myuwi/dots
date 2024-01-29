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

eval "$(starship init bash)"

[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
