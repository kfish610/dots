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
        core.autocrlf = "false";
        init.defaultBranch = "main";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false; # Remove once this is deprecated
      matchBlocks = {
        "lambda" = {
          user = "kfish";
          hostname = "localhost";
          port = 8888;
          proxyJump = "alnilam";
        };
        "alnilam" = {
          hostname = "150.136.100.250";
          user = "pipe";
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
    gh
    git-crypt
    imagemagick
    jq
    fastfetch
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
