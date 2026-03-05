{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    vivaldi = prev.vivaldi.override {
      commandLineArgs = "--ozone-platform=wayland";
    };
  };
}
