{ config, inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  scenefx = inputs.scenefx.packages.${system}.default.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../../patches/scenefx/fix-shadow-clip-inset.patch
      # NVIDIA falls back to mediump, misplacing rounded borders (mangowm/mango#1196)
      ../../patches/scenefx/force-highp-fragment-precision.patch
    ];
  });
in
{
  programs.mango.enable = true;
  programs.mango.package =
    (inputs.mangowm.packages.${system}.mango.override { inherit scenefx; }).overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [
          ../../patches/mango/allow-release-bind-after-other-keys.patch
          ../../patches/mango/keep-app-size-for-tiled-spawn.patch
          ../../patches/mango/skip-mousebind-on-layersurface.patch
        ];
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/share/wayland-sessions/mango.desktop \
            --replace-fail "DesktopNames=mango;wlroots" "DesktopNames=mango;wlroots;X-NIXOS-SYSTEMD-AWARE"
        '';
      });

  environment.systemPackages = [
    pkgs.awww
    pkgs.fuzzel
    pkgs.grim
    pkgs.jq
    pkgs.libnotify
    pkgs.playerctl
    pkgs.quickshell
    pkgs.shikane
    pkgs.slurp
    pkgs.wayfreeze
    pkgs.wl-clip-persist
    pkgs.wl-clipboard
  ];

  # Ships mango-session.target, which mango starts on launch
  systemd.packages = [ config.programs.mango.package ];
}
