{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ghostty
    pkgs.nautilus
    pkgs.file-roller
    pkgs.gnome-calculator
    pkgs.loupe
    pkgs.mpv
    pkgs.gimp
    pkgs.pavucontrol
    pkgs.vesktop
  ];
}
