#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR='nvim'
export VISUAL='nvim'
export HISTCONTROL=ignoreboth

export TOPIARY_CONFIG_FILE="$(realpath ~/.config/topiary/languages.ncl)"
export TOPIARY_LANGUAGE_DIR="$(realpath ~/.config/topiary/languages)"

alias c='clear'
alias ls='eza -a --group-directories-first'
alias ll='eza -la --group-directories-first'
alias cal='cal -mw'
alias yt-dl='yt-dlp'
alias pn='pnpm'
alias lg='lazygit'
alias ld='lazydocker'
alias sxiv='nsxiv'

eval "$(starship init bash)"
eval "$(mise activate bash)"
