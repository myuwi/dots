{ pkgs, ... }:
{
  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/nix-direnv" ];

  environment.systemPackages = [
    # Shell
    pkgs.btop
    pkgs.direnv
    pkgs.eza
    pkgs.file
    pkgs.fzf
    pkgs.nix-direnv
    pkgs.nushell
    pkgs.starship
    pkgs.tmux
    pkgs.unzip
    pkgs.zip

    # Development
    pkgs.claude-code
    pkgs.codex
    pkgs.gcc
    pkgs.git
    pkgs.gh
    pkgs.gh-markdown-preview
    pkgs.gnumake
    pkgs.lazygit
    pkgs.nixfmt

    # Neovim
    pkgs.neovim
    pkgs.fd
    pkgs.ripgrep
    pkgs.tree-sitter

    # LSP
    pkgs.emmet-ls
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.nixd
    pkgs.taplo
    pkgs.typescript-language-server
    pkgs.vscode-langservers-extracted
    pkgs.yaml-language-server

    # Formatters
    pkgs.nufmt
    pkgs.oxfmt
    pkgs.shfmt
    pkgs.stylua
  ];
}
