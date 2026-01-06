{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    vivaldi = prev.vivaldi.override {
      commandLineArgs = "--ozone-platform=wayland";
    };

    vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
      preBuild =
        final.lib.optionalString final.stdenv.hostPlatform.isDarwin ''
          cp -r ${final.electron.dist}/Electron.app .
          chmod -R u+w Electron.app
        ''
        + final.lib.optionalString final.stdenv.hostPlatform.isLinux ''
          cp -r ${final.electron.dist} electron-dist
          chmod -R u+w electron-dist
        '';

      buildPhase =
        let
          electronDistPath = if final.stdenv.hostPlatform.isDarwin then "." else "electron-dist";
          originalBuildPhase = oldAttrs.buildPhase or "";
        in
        builtins.replaceStrings
          [ "-c.electronDist=${final.electron.dist}" ]
          [ "-c.electronDist=${electronDistPath}" ]
          originalBuildPhase;
    });
  };
}
