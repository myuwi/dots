export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

export EDITOR='nvim'
export VISUAL='nvim'

export DOTFILES_DIR=$HOME/.dots

typeset -U path PATH
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $DOTFILES_DIR/bin(N)
  $path
)
export PATH
