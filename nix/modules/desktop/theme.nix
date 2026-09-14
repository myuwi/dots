{ pkgs, ... }:
{
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "adw-gtk3";
        icon-theme = "Adwaita";
        cursor-theme = "Adwaita";
        color-scheme = "default";
      };
    }
  ];

  environment.systemPackages = [
    pkgs.adw-gtk3
    pkgs.adwaita-icon-theme
  ];
}
