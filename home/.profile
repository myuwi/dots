
prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

prepend_path "$HOME/.cargo/bin"
prepend_path "$HOME/.local/bin"

unset -f prepend_path
export PATH
