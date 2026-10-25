{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.swayidle
    pkgs.wlopm
  ];

  systemd.user.services.swayidle = {
    description = "Idle management daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.wlopm ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.swayidle} -w";
      Restart = "on-failure";
    };
  };

  systemd.user.services.wayland-pipewire-idle-inhibit = {
    description = "Inhibit idle while media is playing";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.wayland-pipewire-idle-inhibit;
      Restart = "on-failure";
    };
  };
}
