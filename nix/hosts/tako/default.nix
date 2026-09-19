{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/shell.nix
    ../../modules/nvidia.nix
    ../../modules/desktop
  ];

  networking.hostName = "tako";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
