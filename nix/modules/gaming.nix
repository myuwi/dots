{ pkgs, ... }:
{
  programs.solaar.enable = true;
  # GUI changes to dpi_extended are applied to the mouse but never saved to config.yaml
  programs.solaar.package = pkgs.solaar.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/solaar/persist-dpi-extended.patch ];
  });

  hardware.wooting.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs.osu-lazer-bin
  ];
}
