{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.format = "ssh";
    settings = {
      user.name = "Kevin Fisher";
      user.email = "kfish610@gmail.com";
      pull.ff = "only";
      push.autoSetupRemote = true;
      core.autocrlf = "false";
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [
    gh
    git-crypt
  ];
}
