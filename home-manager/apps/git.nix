{ ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
    lfs.enable = true;
    userName = "vinniefranco";
    userEmail = "vince@freshivore.net";
  };
}
