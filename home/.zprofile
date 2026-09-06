export DOTFILES_DIR=$HOME/.dots

typeset -U path PATH
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $DOTFILES_DIR/bin(N)
  $path
)
export PATH
