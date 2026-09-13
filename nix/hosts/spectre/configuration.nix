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
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "adw-gtk3";
        icon-theme = "Adwaita";
        cursor-theme = "Adwaita";
        color-scheme = "default";
      };
    }
  ];
  hardware.brillo.enable = true;
  systemd.user.services.brillo-min-cap = {
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.brillo}/bin/brillo -qc -S 25";
    };
  };
  services.thermald.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.ssh.enableAskPassword = true;
  programs.ssh.askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";
  systemd.packages = [
    pkgs.gcr_4
    pkgs.xdg-user-dirs
  ];
  systemd.user.sockets.gcr-ssh-agent.wantedBy = [ "sockets.target" ];
  systemd.user.services.xdg-user-dirs.wantedBy = [ "graphical-session.target" ];
  environment.etc."xdg/user-dirs.defaults".text = ''
    DOWNLOAD=Downloads
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
    PROJECTS=Projects
  '';

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.inter
    pkgs.material-symbols
    pkgs.noto-fonts
    (pkgs.runCommand "murecho" { } ''
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

    # Mango
    pkgs.adw-gtk3
    pkgs.adwaita-icon-theme
    pkgs.awww
    pkgs.fuzzel
    pkgs.grim
    pkgs.jq
    pkgs.libnotify
    pkgs.lxqt.lxqt-policykit
    pkgs.playerctl
    pkgs.quickshell
    pkgs.shikane
    pkgs.slurp
    pkgs.swayidle
    pkgs.wl-clip-persist
    pkgs.wl-clipboard
    pkgs.wlopm

    # Apps
    pkgs.firefox
    pkgs.ghostty
    pkgs.nautilus
    pkgs.file-roller
    pkgs.loupe
    pkgs.mpv
    pkgs.gimp
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
