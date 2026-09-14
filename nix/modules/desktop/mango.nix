{ inputs, pkgs, ... }:
{
  programs.mango.enable = true;
  # Pinned before scenefx 0.5 (mangowm/mango#1196), plus a layer-surface guard
  programs.mango.package =
    inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ../../patches/mango-buttonpress-skip-layersurface.patch ];
      });

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
