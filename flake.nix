{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    ags-bar = {
      url = "path:/home/vinnie/.dotfiles/pkgs/ags";
    };

    ucodenix.url = "github:e-tho/ucodenix";
    walker.url = "github:abenz1267/walker";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:vinniefranco/nixvim-config";

    ags.url = "github:Aylur/ags";
  };

  outputs =
    {
      self,
      nixpkgs,
      ags-bar,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        v3 = nixpkgs.lib.nixosSystem {
          modules = [ ./system/v3/configuration.nix ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      homeConfigurations = {
        vinnie = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-manager/home.nix ];

          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
