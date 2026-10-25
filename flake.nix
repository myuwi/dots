{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.scenefx.follows = "scenefx";
    };
    # Patched in nix/modules/desktop/mango.nix; tracks main ahead of mango's lock.
    scenefx = {
      url = "github:wlrfx/scenefx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qmljsfmt = {
      url = "github:myuwi/qmljsfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vencord-plugins = {
      url = "github:myuwi/vencord-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.spectre = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          ./nix/hosts/spectre/disk-config.nix
          ./nix/hosts/spectre
        ];
      };

      nixosConfigurations.tako = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          ./nix/hosts/tako/disk-config.nix
          ./nix/hosts/tako
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.qt6.qtdeclarative
          inputs.qmljsfmt.packages.${system}.default
        ];
      };
    };
}
