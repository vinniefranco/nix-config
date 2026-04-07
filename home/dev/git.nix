{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };
      pull.rebase = true;

      user.name = "vinniefranco";
      user.email = "vince@freshivore.net";
    };
    lfs.enable = true;
  };
}
