{ pkgs, ... }:
let
  profilesIni = pkgs.writeText "profiles.ini" ''
    [General]
    StartWithLastProfile=1
    Version=2

    [Profile0]
    Name=default
    IsRelative=1
    Path=default
    Default=1
  '';
in
{
  programs.firefox = {
    enable = true;
    preferences = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      # Compositor frame-callback vsync flickers on scroll/zoom under mango.
      "widget.wayland.vsync.enabled" = false;
      "browser.nova.enabled" = false;
    };
  };

  systemd.user.tmpfiles.users.miika.rules = [
    "d %h/.config/mozilla/firefox/default 0700 - - -"
    "C %h/.config/mozilla/firefox/profiles.ini 0600 - - - ${profilesIni}"
  ];
}
