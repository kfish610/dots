{ pkgs, ... }:

{
  home.pointerCursor.enable = true; # TODO: Delete this when Stylix (presumably) updates

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

    ssh = {
      enable = true;
      enableDefaultConfig = false; # Remove once this is deprecated
      settings = {
        "lambda" = {
          HostName = "lambda.cs.illinois.edu";
          User = "kfish";
          ForwardAgent = true;
        };
        "icc" = {
          HostName = "cc-login.campuscluster.illinois.edu";
          User = "kf23";
          ForwardAgent = true;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
        "icc-cpu" = {
          HostName = "cc-login.campuscluster.illinois.edu";
          User = "kf23";
          ForwardAgent = true;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
          RemoteCommand = "./vscode.sh cpu";
          RequestTTY = true;
        };
        "icc-gpu" = {
          HostName = "cc-login.campuscluster.illinois.edu";
          User = "kf23";
          ForwardAgent = true;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
          RemoteCommand = "./vscode.sh gpu";
          RequestTTY = true;
        };
        "icc-gpu-preempt" = {
          HostName = "cc-login.campuscluster.illinois.edu";
          User = "kf23";
          ForwardAgent = true;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
          RemoteCommand = "./vscode.sh gpu-preempt";
          RequestTTY = true;
        };
        "unity" = {
          HostName = "unity.rc.umass.edu";
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
        };
        "*.unity.rc.umass.edu" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyJump = "unity";
        };
        "unity-cpu" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyCommand = "ssh unity './vscode.sh cpu'";
          StrictHostKeyChecking = "no";
        };
        "unity-gpu" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyCommand = "ssh unity './vscode.sh gpu'";
          StrictHostKeyChecking = "no";
        };
        "unity-gpu-preempt" = {
          User = "kfisher_access-ci_org";
          ForwardAgent = true;
          ProxyCommand = "ssh unity './vscode.sh gpu-preempt'";
          StrictHostKeyChecking = "no";
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
    ollama

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
