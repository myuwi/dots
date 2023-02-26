#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$(go env GOPATH)/bin

export DOTFILES=$HOME/.dotfiles
[[ -d $DOTFILES/bin ]] && export PATH=$DOTFILES/bin:$PATH
