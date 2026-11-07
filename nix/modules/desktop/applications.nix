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
    pkgs.proton-vpn
    pkgs.qbittorrent
    (pkgs.vesktop.override {
      withSystemVencord = true;
      # TODO: back to pkgs.vencord once NixOS/nixpkgs#584169 reaches unstable
      vencord =
        (pkgs.callPackage "${inputs.nixpkgs-vencord}/pkgs/by-name/ve/vencord/package.nix" { })
        .overrideAttrs
          (old: {
            postPatch = (old.postPatch or "") + ''
              cp -r ${inputs.vencord-plugins}/plugins src/userplugins
            '';
          });
    })
  ];
}
