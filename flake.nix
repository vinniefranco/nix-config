{
  description = "Nixos config flake";

  nixConfig = {
    extra-trusted-substituters = [ "https://rock5b-nixos.cachix.org" ];
    extra-trusted-public-keys = [
      "rock5b-nixos.cachix.org-1:bXHDewFS0d8pT90A+/YZan/3SjcyuPZ/QRgRSuhSPnA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    rock5b-nixos.url = "github:aciceri/rock5b-nixos";
    rock5b-nixos.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      rock5b-nixos,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (final: prev: { chromium = prev.chromium.override { enableWideVine = true; }; }) ];
      };
    in
    {
      overlays = lib.packagesFromDirectoryRecursive {
        callPackage = path: overrides: import path;
        directory = ./overlays;
      };

      nixosConfigurations = {
        rocky = nixpkgs.lib.nixosSystem {
          modules = [
            ./system/rocky/configuration.nix
            rock5b-nixos.nixosModules.kernel
            rock5b-nixos.nixosModules.fan-control
          ];
          system = [
            "aarch64-linux"
            "x86_64-linux"
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        v3 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ stylix.nixosModules.stylix ./system/v3/configuration.nix ];
          specialArgs = {
            inherit inputs system;
          };
        };
      };

      homeConfigurations = {
        vinnie = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            stylix.homeManagerModules.stylix
            ./home.nix
          ];

          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
