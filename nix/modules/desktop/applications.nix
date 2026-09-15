{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ghostty
    pkgs.nautilus
    pkgs.file-roller
    pkgs.loupe
    pkgs.mpv
    pkgs.gimp
    pkgs.vesktop
  ];
}
