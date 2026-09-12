HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nonomatch nobeep hist_ignore_dups hist_ignore_space

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

command -v mise >/dev/null && eval "$(mise activate zsh)"
eval "$(starship init zsh)"

export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"
