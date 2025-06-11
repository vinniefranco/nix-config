{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      corefonts
      font-awesome
      helvetica-neue-lt-std
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      vistafonts
    ];
    fontconfig.subpixel.rgba = "rgb";
    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Source Han Serif"
      ];
      sansSerif = [
        "Noto Sans"
        "Source Han Sans"
      ];
    };
  };
}
