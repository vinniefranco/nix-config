{ inputs, ... }:
let
  modifications = final: prev: {
    chromium = prev.chromium.override { enableWideVine = true; };
    openscad = prev.openscad.overrideAttrs (
      f: pA: {
        postPatch = ''
          substituteInPlace src/FileModule.cc \
            --replace-fail 'fs::is_regular' 'fs::is_regular_file'
        '';
      }
    );
    orca-slicer = prev.orca-slicer.overrideAttrs (
      f: pA: {
        cmakeFlags = prev.lib.remove "-DFLATPAK=1" pA.cmakeFlags;
      }
    );
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
