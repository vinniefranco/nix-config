{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    ucodenix.url = "github:e-tho/ucodenix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixos-cosmic,
      nixpkgs,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (final: prev: { chromium = prev.chromium.override { enableWideVine = true; }; }) ];
      };
    in
    {
      nixosConfigurations = {
        v3 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            stylix.nixosModules.stylix
            ./system/v3/configuration.nix
          ];
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
