{ inputs, ... }:
let
  modifications = final: prev: {
    chromium = prev.chromium.override { enableWideVine = true; };
    orca-slicer = prev.orca-slicer.overrideAttrs (
      f: pA: {
        cmakeFlags = prev.lib.remove "-DFLATPAK=1" pA.cmakeFlags;
      }
    );
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
