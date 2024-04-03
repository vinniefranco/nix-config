{ pkgs, ... }: 

pkgs.writeShellScriptBin "screenshoter" ''
  ${builtins.readFile ./config/screenshoter.sh}
''
