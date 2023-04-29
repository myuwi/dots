#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$(go env GOPATH)/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export DOTFILES=$HOME/.dots
[[ -d $DOTFILES/bin ]] && export PATH=$DOTFILES/bin:$PATH
