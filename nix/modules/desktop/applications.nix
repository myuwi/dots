{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ghostty
    pkgs.nautilus
    pkgs.file-roller
    pkgs.gnome-calculator
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    pkgs.loupe
    pkgs.mpv
    # Force X11: GIMP's Preferences (Input Devices) crashes on native Wayland (GNOME/gimp#7609)
    (pkgs.symlinkJoin {
      name = "gimp";
      paths = [ pkgs.gimp ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for bin in gimp gimp-3 gimp-3.2; do
          wrapProgram $out/bin/$bin --set GDK_BACKEND x11
        done
      '';
    })
    pkgs.pavucontrol
    (pkgs.vesktop.override {
      withSystemVencord = true;
      vencord = pkgs.vencord.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          cp -r ${../../vencord-plugins} src/userplugins
        '';
      });
    })
  ];
}
