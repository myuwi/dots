{ inputs, pkgs, ... }:
{
  programs.mango.enable = true;
  # Pinned before scenefx 0.5 (mangowm/mango#1196), plus a mousebind guard.
  programs.mango.package =
    inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ../../patches/mango/skip-mousebind-on-layersurface.patch ];
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

  systemd.user.services.swayidle = {
    description = "Idle management daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w";
      Restart = "on-failure";
    };
  };
}
