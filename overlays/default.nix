{ inputs, ... }:
let
  modifications = final: prev: {
    chromium = prev.chromium.override { enableWideVine = true; };
    freecad-wayland = prev.freecad-wayland.overrideAttrs (old: {
      version = "1.0rc4";
      src = prev.fetchFromGitHub {
        owner = "FreeCAD";
        repo = "FreeCAD";
        rev = "1.0rc4";
        hash = "sha256-b7aeVQkgdsDRdnVIr+5ZNuWAm6GLH7sepa8kFp2Zm2U=";
      };
      patches = inputs.nixpkgs-unstable.lib.lists.take 2 old.patches;
    });
  };
in
{
  modifications = modifications;

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      overlays = [ modifications ];
    };
  };
}
