{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.firefox
    pkgs.ghostty
    pkgs.nautilus
    pkgs.file-roller
    pkgs.loupe
    pkgs.mpv
    pkgs.gimp
    pkgs.vesktop
  ];
}
