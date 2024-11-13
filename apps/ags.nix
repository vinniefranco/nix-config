{ inputs, pkgs-unstable, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    extraPackages = with pkgs-unstable; [
      accountsservice
      gnome.gvfs
      gtksourceview
      webkitgtk
    ];
  };
}
