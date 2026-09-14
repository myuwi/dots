{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.inter
    pkgs.material-symbols
    pkgs.noto-fonts
    (pkgs.runCommand "murecho" { } ''
      install -Dm444 ${
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/google/fonts/5174b3333331c966c38f4355d50b03ca1c1df2f9/ofl/murecho/Murecho%5Bwght%5D.ttf";
          hash = "sha256-Oic8LxHgFk+Cm8FcBonlh/400Uk/8WfVr/+P5xop5mc=";
        }
      } $out/share/fonts/truetype/Murecho.ttf
    '')
  ];
  fonts.fontconfig.defaultFonts = {
    serif = [ ];
    sansSerif = [ ];
    monospace = [ ];
  };
}
