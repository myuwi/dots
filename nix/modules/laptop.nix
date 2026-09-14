{ pkgs, ... }:
{
  hardware.brillo.enable = true;
  systemd.user.services.brillo-min-cap = {
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.brillo}/bin/brillo -qc -S 25";
    };
  };
  services.thermald.enable = true;
  services.upower.enable = true;
}
