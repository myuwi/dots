{ pkgs, ... }:
{
  systemd.packages = [ pkgs.xdg-user-dirs ];
  systemd.user.services.xdg-user-dirs.wantedBy = [ "graphical-session.target" ];
  environment.etc."xdg/user-dirs.defaults".text = ''
    DOWNLOAD=Downloads
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
    PROJECTS=Projects
  '';
}
