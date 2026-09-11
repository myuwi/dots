{
  description = "NixOS configuration for spectre";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }:
    {
      nixosConfigurations.spectre = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./nix/hosts/spectre/disk-config.nix
          ./nix/hosts/spectre/configuration.nix
        ];
      };
    };
}
