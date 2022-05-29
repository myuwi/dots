#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH=$HOME/scripts:$PATH:$HOME/.local/bin:$(yarn global bin):$HOME/.cargo/bin
