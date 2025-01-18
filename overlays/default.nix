{ inputs, ... }:
let
  modifications = final: prev: {
    chromium = prev.chromium.override { enableWideVine = true; };
  };
in
{
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = modifications;

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      overlays = [
        modifications
      ];
    };
  };
}
