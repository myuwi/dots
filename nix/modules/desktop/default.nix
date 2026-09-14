{ ... }:
{
  imports = [
    ./applications.nix
    ./fonts.nix
    ./keyring.nix
    ./mango.nix
    ./theme.nix
    ./xdg.nix
  ];

  services.displayManager.ly = {
    enable = true;
    x11Support = false;
  };

  services.gvfs.enable = true;
}
