{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Kevin Fisher";
      userEmail = "kfish610@gmail.com";
      extraConfig = {
        pull.ff = "only";
        core.autocrlf = "false";
        init.defaultBranch = "main";
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "unity" = {
          hostname = "unity.rc.umass.edu";
          user = "kfisher_access-ci_org";
          forwardAgent = true;
        };
        "*.unity.rc.umass.edu" = rec {
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyJump = "unity";
        };
        "unity-cpu" = {
          hostname = "*.unity.rc.umass.edu";
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyCommand = "ssh -o StrictHostKeyChecking=no unity './vscode.sh'";
        };
        "unity-gpu" = {
          hostname = "*.unity.rc.umass.edu";
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          proxyCommand = "ssh -o StrictHostKeyChecking=no unity './vscode.sh gpu'";
        };
        "south" = {
          hostname = "south.ucsd.edu";
          user = "ubuntu";
          identityFile = "~/.ssh/ucsd";
          identitiesOnly = true;
          forwardAgent = true;
          port = 17400;
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
    imagemagick
    jq
    neofetch
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
