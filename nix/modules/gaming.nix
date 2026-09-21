{ pkgs, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs.osu-lazer-bin
  ];
}
