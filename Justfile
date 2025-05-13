help:
  @just --list

stow:
  stow -t $HOME home

stow-adopt:
  stow -t $HOME home --adopt

unstow:
  stow -t $HOME -D home
