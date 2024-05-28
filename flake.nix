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

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    rock5b-nixos.url = "github:aciceri/rock5b-nixos";
    rock5b-nixos.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, rock5b-nixos, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        rocky = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./system/rocky/configuration.nix
            rock5b-nixos.nixosModules.kernel
            rock5b-nixos.nixosModules.fan-control
          ];
        };

        v3 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./system/v3/configuration.nix ];
          specialArgs = {
            inherit inputs;
          };
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
