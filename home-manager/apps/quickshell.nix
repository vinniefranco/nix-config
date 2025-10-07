{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell
  ];

  programs.dankMaterialShell = {
    enable = true;
    enableSpawn = true;
    enableCalendarEvents = false;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # Service used by DMS
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
