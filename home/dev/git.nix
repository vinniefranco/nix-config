{ ... }:

{
  programs.git = {
    enable = true;
    delta.enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autosquash = true;
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";
      rerere.enabled = true;

      user.name = "vinniefranco";
      user.email = "vince@freshivore.net";
    };
    lfs.enable = true;
  };
}
