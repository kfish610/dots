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
        "unity-alloc" = rec {
          hostname = "unity.rc.umass.edu";
          user = "kfisher_access-ci_org";
          forwardAgent = true;
          extraOptions = {
            RemoteCommand = "salloc -p cpu -t 2:00:00 -N 1 -D ~";
            RequestTTY = "yes";
          };
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
    expect
    gh
    imagemagick
    neofetch
    pandoc
    unzip
    xidel

    # Applications
    google-chrome
    nautilus

    # Networking
    avahi
    dig
    inetutils
    sshpass
    tcptraceroute
    wget
  ];
}
