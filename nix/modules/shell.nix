{ pkgs, lib, ... }:
let
  neovim = pkgs.neovim.override {
    extraMakeWrapperArgs = "--suffix PATH : ${
      lib.makeBinPath [
        pkgs.tree-sitter

        # LSP
        pkgs.emmet-ls
        pkgs.lua-language-server
        pkgs.marksman
        pkgs.nixd
        pkgs.taplo
        pkgs.tailwindcss-language-server
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
      ]
    }";
  };
in
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

    # Neovim
    neovim
    pkgs.fd
    pkgs.ripgrep

    # Formatters
    pkgs.nixfmt
    pkgs.nufmt
    pkgs.oxfmt
    pkgs.shfmt
    pkgs.stylua
  ];
}
