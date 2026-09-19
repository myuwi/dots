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
    ../../modules/capture.nix
    ./pipewire.nix
  ];

  networking.hostName = "tako";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap.enable = true;

  fileSystems."/mnt/hdd1" = {
    device = "/dev/disk/by-uuid/CA1A8FE81A8FD03D";
    fsType = "ntfs3";
    options = [ "uid=1000" "nofail" ];
  };

  system.stateVersion = "26.05";
}
