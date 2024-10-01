{ pkgs, ... }:
let
  freecadv1 = pkgs.freecad.overrideAttrs (
    final: prev: {

      version = "1.0rc2";
      src = pkgs.fetchFromGitHub {
        owner = "FreeCAD";
        repo = "FreeCAD";
        rev = "1.0rc2";
        hash = "sha256-3/78HJbxhCtwCDgrAGFRV2E0a51OQwsEQ4KZ3If7OQU=";
      };

      prePatch =
        let
          ondselSolver = pkgs.fetchFromGitHub {
            owner = "Ondsel-Development";
            repo = "OndselSolver";
            rev = "6bf651cd31dfdcde8d6842b492b93d284f4579fe";
            hash = "sha256-ONxFATHIHKfzxDeIJlIMl2u/ZMahIk46+T2h4Ac+qrQ=";
          };
          googletest = pkgs.fetchFromGitHub {
            owner = "google";
            repo = "googletest";
            rev = "v1.15.2";
            hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
          };
        in
        prev.prePatch or ""
        + ''
          cp -r ${ondselSolver}/* src/3rdParty/OndselSolver
          chmod -R +w src/3rdParty/OndselSolver
          cp -r ${googletest} tests/lib/googletest
          echo "add_subdirectory(googletest)" > tests/lib/CMakeLists.txt
          chmod -R +w tests/lib
        '';

      patches = [
        ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch
        ./0002-FreeCad-OndselSolver-pkgconfig.patch
      ];

      buildInputs = prev.buildInputs or [] ++ [
        pkgs.yaml-cpp
        pkgs.microsoft-gsl
      ];

      cmakeFlags = prev.cmakeFlags or [] ++ [
        "-DINSTALL_TO_SITEPACKAGES:BOOL=OFF"
      ];

      preBuild =
        prev.preBuild or ""
        + ''
          export NIX_LDFLAGS="-L${pkgs.yaml-cpp}/lib $NIX_LDFLAGS";
        '';
    }
  );
in
{
  environment.systemPackages =  [
    freecadv1
  ];
}
