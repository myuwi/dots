{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

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

  environment.systemPackages = [
    pkgs.git
    pkgs.neovim
  ];

  system.stateVersion = "26.05";
}
