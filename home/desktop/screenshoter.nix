{ pkgs, ... }:

pkgs.writeShellScriptBin "screenshoter" ''
  ${builtins.readFile ./screenshoter.sh}
''
