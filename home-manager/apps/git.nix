{ ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull.rebase = true;
    };
    lfs.enable = true;
    userName = "vinniefranco";
    userEmail = "vince@freshivore.net";
  };
}
