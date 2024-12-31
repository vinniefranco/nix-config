{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://cosmic.cachix.org/"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    astal-bar.url = "github:vinniefranco/astal-for-hypr";

    ghostty.url = "github:ghostty-org/ghostty";
    ucodenix.url = "github:e-tho/ucodenix";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:vinniefranco/nixvim-config";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-cosmic,
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
          modules = [
            nixos-cosmic.nixosModules.default
            ./system/v3/configuration.nix
          ];
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
