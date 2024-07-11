{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
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
      };
    in
    {
      overlays = lib.packagesFromDirecttoryRecursive {
        callPackage = path: overrides: import path;
        directory = "./overlays";
      };

      nixosConfigurations = {
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
