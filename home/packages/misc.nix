{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Kevin Fisher";
        user.email = "kfish610@gmail.com";
        pull.ff = "only";
        push.autoSetupRemote = true;
        core.autocrlf = "false";
        init.defaultBranch = "main";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false; # Remove once this is deprecated
      matchBlocks = {
        "lambda" = {
          hostname = "lambda.cs.illinois.edu";
          user = "kfish";
          forwardAgent = true;
        };
        "unity" = {
          hostname = "unity.rc.umass.edu";
          user = "kfisher_access-ci_org";
          forwardAgent = true;
        };
        "*.unity.rc.umass.edu" = {
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyJump = "unity";
        };
        "unity-cpu" = {
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyCommand = "ssh unity './vscode.sh cpu'";
          extraOptions.StrictHostKeyChecking = "no";
        };
        "unity-gpu" = {
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyCommand = "ssh unity './vscode.sh gpu'";
          extraOptions.StrictHostKeyChecking = "no";
        };
        "unity-gpu-preempt" = {
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyCommand = "ssh unity './vscode.sh gpu-preempt'";
          extraOptions.StrictHostKeyChecking = "no";
        };
      };
    };

    keychain = {
      enable = true;
      keys = [ "id_ed25519" ];
    };
  };

  home.packages = with pkgs; [
    # Applications
    google-chrome
    nautilus

    # Tools
    fastfetch
    gh
    git-crypt
    graphviz
    imagemagick
    jq
    ncdu
    nix-index
    pandoc
    unzip
    xidel

    # Networking
    avahi
    dig
    sshpass
    traceroute
    tcptraceroute
    wget
  ];
}
