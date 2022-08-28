#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

source /usr/share/nvm/init-nvm.sh

export PATH=$HOME/scripts:$PATH:$HOME/.local/bin:$(yarn global bin):$HOME/.cargo/bin:$(go env GOPATH)/bin
