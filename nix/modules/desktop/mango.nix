{ inputs, pkgs, ... }:
{
  programs.mango.enable = true;
  # Pinned before scenefx 0.5 (mangowm/mango#1196), plus a mousebind guard.
  programs.mango.package =
    inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ../../patches/mango/skip-mousebind-on-layersurface.patch ];
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
    pkgs.lxqt.lxqt-policykit
    pkgs.playerctl
    pkgs.quickshell
    pkgs.shikane
    pkgs.slurp
    pkgs.wayfreeze
    pkgs.wl-clip-persist
    pkgs.wl-clipboard
  ];

  systemd.user.targets.mango-session = {
    description = "mango compositor session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };
}
