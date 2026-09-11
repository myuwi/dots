export DOTFILES_DIR=$HOME/.dots

prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

[ -d "$DOTFILES_DIR/bin" ] && prepend_path "$DOTFILES_DIR/bin"
prepend_path "$HOME/.cargo/bin"
prepend_path "$HOME/.local/bin"

unset -f prepend_path
export PATH
