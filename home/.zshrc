export EDITOR='nvim'
export VISUAL='nvim'

export TOPIARY_CONFIG_FILE=$HOME/.config/topiary/languages.ncl
export TOPIARY_LANGUAGE_DIR=$HOME/.config/topiary/languages

export DOTFILES_DIR=$HOME/.dots

typeset -U path PATH
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $DOTFILES_DIR/bin(N)
  $path
)
export PATH

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nonomatch nobeep

alias ls='eza -a --group-directories-first'
alias ll='eza -la --group-directories-first'
alias cal='cal -mw'
alias yt-dl='yt-dlp'
alias lg='lazygit'
alias ld='lazydocker'
alias sxiv='nsxiv'

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word
bindkey "^[[3~" delete-char

eval "$(mise activate zsh)"
eval "$(starship init zsh)"
