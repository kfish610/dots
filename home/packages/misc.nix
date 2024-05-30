{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
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
  };

  services.ssh-agent.enable = true;

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
    gnome.nautilus

    # Networking
    avahi
    dig
    inetutils
    sshpass
    tcptraceroute
    wget
  ];
}
