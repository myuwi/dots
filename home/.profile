
prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

[ -d "$HOME/.dots/bin" ] && prepend_path "$HOME/.dots/bin"
prepend_path "$HOME/.cargo/bin"
prepend_path "$HOME/.local/bin"

unset -f prepend_path
export PATH
