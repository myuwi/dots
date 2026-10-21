{ lib, pkgs, ... }:
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

  # Use the GNOME portal (libadwaita dialogs; FileChooser is delegated to Nautilus) for
  # dialogs only. Its other interfaces need gnome-shell/mutter, so keep gtk as default.
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  xdg.portal.config.mango = lib.mkForce {
    default = [ "gtk" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
    "org.freedesktop.impl.portal.AppChooser" = [ "gnome" ];
    "org.freedesktop.impl.portal.Print" = [ "gnome" ];
    "org.freedesktop.impl.portal.Access" = [ "gnome" ];
    "org.freedesktop.impl.portal.Account" = [ "gnome" ];
    "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
    "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
  };
}
