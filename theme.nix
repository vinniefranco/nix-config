# Single source of truth for desktop theming (cursor, icons, GTK).
# Imported by both system and home modules so a value is set once here and
# every reference updates. Usage: `let theme = import ../theme.nix { inherit pkgs; };`
{ pkgs }:
let
  flavor = "mocha";
  accent = "blue";
in
{
  inherit flavor accent;

  cursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 32;
  };

  icons = {
    name = "Papirus-Dark";
    package = pkgs.catppuccin-papirus-folders.override { inherit flavor accent; };
  };

  gtk = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
}
