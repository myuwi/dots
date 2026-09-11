{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.mangowm.nixosModules.mango
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.tmp.cleanOnBoot = true;

  boot.blacklistedKernelModules = [
    "intel_ish_ipc"
    "pcspkr"
    "snd_pcsp"
  ];

  networking.hostName = "spectre";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fi";
  services.xserver.xkb.layout = "fi";

  programs.zsh.enable = true;

  services.displayManager.ly = {
    enable = true;
    x11Support = false;
  };

  programs.mango.enable = true;
  programs.dconf.enable = true;
  hardware.brillo.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.inter
    pkgs.material-symbols
    pkgs.noto-fonts
    (pkgs.runCommandNoCC "murecho" { } ''
      install -Dm444 ${
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/google/fonts/5174b3333331c966c38f4355d50b03ca1c1df2f9/ofl/murecho/Murecho%5Bwght%5D.ttf";
          hash = "sha256-Oic8LxHgFk+Cm8FcBonlh/400Uk/8WfVr/+P5xop5mc=";
        }
      } $out/share/fonts/truetype/Murecho.ttf
    '')
  ];
  fonts.fontconfig.defaultFonts = {
    serif = [ ];
    sansSerif = [ ];
    monospace = [ ];
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];

  environment.systemPackages = [
    # Shell
    pkgs.direnv
    pkgs.eza
    pkgs.fzf
    pkgs.nix-direnv
    pkgs.starship
    pkgs.tmux

    # Development
    pkgs.claude-code
    pkgs.gcc
    pkgs.git
    pkgs.gnumake
    pkgs.lazygit
    pkgs.stow

    # Neovim
    pkgs.fd
    pkgs.neovim
    pkgs.ripgrep
    pkgs.tree-sitter
    pkgs.unzip

    # Nix
    pkgs.nixfmt

    # Mango
    pkgs.adwaita-icon-theme
    pkgs.awww
    pkgs.fuzzel
    pkgs.grim
    pkgs.jq
    pkgs.lxqt.lxqt-policykit
    pkgs.playerctl
    pkgs.shikane
    pkgs.slurp
    pkgs.wl-clip-persist
    pkgs.wl-clipboard

    # Apps
    pkgs.firefox
    pkgs.ghostty
    pkgs.nautilus
    pkgs.vesktop
  ];

  users.users.miika = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  system.stateVersion = "26.05";
}
