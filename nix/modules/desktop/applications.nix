{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ghostty
    pkgs.nautilus
    pkgs.file-roller
    pkgs.gnome-calculator
    pkgs.loupe
    pkgs.mpv
    # Force X11: GIMP's Preferences (Input Devices) crashes on native Wayland (GNOME/gimp#7609)
    (pkgs.symlinkJoin {
      name = "gimp";
      paths = [ pkgs.gimp ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/gimp --set GDK_BACKEND x11
      '';
    })
    pkgs.pavucontrol
    pkgs.vesktop
  ];
}
