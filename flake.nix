{
  description = "Nixos config flake";

  nixConfig = {
    extra-trusted-substituters = [ "https://rock5b-nixos.cachix.org" ];
    extra-trusted-public-keys = [
      "rock5b-nixos.cachix.org-1:bXHDewFS0d8pT90A+/YZan/3SjcyuPZ/QRgRSuhSPnA="
    ];
  };

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";

    rock5b-nixos.url = "github:aciceri/rock5b-nixos";
    rock5b-nixos.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      rock5b-nixos,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        surface = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/surface/configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ];
        };

        rocky = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./system/rocky/configuration.nixpkgs
            rock5b-nixos.nixosModules.kernel
            rock5b-nixos.nixosModules.fan-control
          ];
        };
      };

      homeConfigurations = {
        vinnie = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ./home.nix ];

          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
