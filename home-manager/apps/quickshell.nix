{
  pkgs,
  inputs,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
in {
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell
  ];

  programs.dankMaterialShell = {
    enable = true;
    enableSpawn = true;
    enableCalendarEvents = false;

    quickshell.package = quickshell;
  };

  # Service used by DMS
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
