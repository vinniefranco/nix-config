{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "JetBrainsMono"
        ];
      })
      helvetica-neue-lt-std
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      corefonts
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
