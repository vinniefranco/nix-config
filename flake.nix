{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";

    ucodenix.url = "github:e-tho/ucodenix";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:vinniefranco/nixvim-config";

    mcmojave-hyprcursor.url = "github:libadoxon/mcmojave-hyprcursor";

    ags.url = "github:Aylur/ags";
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkg: true);
        config.chromium.enableWideVine = true;
        overlays = [ (final: prev: { chromium = prev.chromium.override { enableWideVine = true; }; }) ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkg: true);
        overlays = [ (final: prev: { chromium = prev.chromium.override { enableWideVine = true; }; }) ];
      };
    in
    {
      nixosConfigurations = {
        v3 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            #stylix.nixosModules.stylix
            ./system/v3/configuration.nix
          ];
          specialArgs = {
            inherit inputs pkgs-unstable system;
          };
        };
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      homeConfigurations = {
        vinnie = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            #stylix.homeManagerModules.stylix
            ./home.nix
          ];

          extraSpecialArgs = {
            inherit inputs pkgs-unstable system;
          };
        };
      };
    };
}
