{ inputs, pkgs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    extraPackages = with pkgs; [
      accountsservice
      gnome.gvfs
      gtksourceview
      webkitgtk
    ];
  };
}
