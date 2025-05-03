help:
  @just --list

stow:
  stow -t $HOME home

unstow:
  stow -t $HOME -D home
