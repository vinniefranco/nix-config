{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
    enableCalendarEvents = false;
    enableSystemd = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.system}.default;
  };

  # Service used by DMS
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
