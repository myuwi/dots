{ inputs, pkgs, ... }:
{
  imports = [ inputs.mangowm.nixosModules.mango ];

  programs.mango.enable = true;

  environment.systemPackages = [
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
  ];
}
