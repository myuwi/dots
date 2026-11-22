{ inputs, pkgs, ... }:
let
  osu-lazer-bin = pkgs.symlinkJoin {
    name = "osu-lazer-bin-low-latency";
    paths = [
      (pkgs.callPackage "${inputs.nixpkgs-osu}/pkgs/by-name/os/osu-lazer-bin/package.nix" {
        nativeWayland = true;
      })
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/osu!" --set PIPEWIRE_LATENCY 128/44100
    '';
  };
in
{
  programs.solaar.enable = true;
  # GUI changes to dpi_extended are applied to the mouse but never saved to config.yaml
  programs.solaar.package = pkgs.solaar.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/solaar/persist-dpi-extended.patch ];
  });

  hardware.wooting.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = [
    osu-lazer-bin
  ];
}
