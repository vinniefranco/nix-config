{ inputs, ... }:
let
  modifications = final: prev: {
    chromium = prev.chromium.override { enableWideVine = true; };
  };
in
{
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = modifications;
}
