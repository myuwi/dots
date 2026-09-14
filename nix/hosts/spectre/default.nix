{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/shell.nix
    ../../modules/laptop.nix
    ../../modules/desktop
  ];

  networking.hostName = "spectre";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "intel_ish_ipc" ];

  system.stateVersion = "26.05";
}
