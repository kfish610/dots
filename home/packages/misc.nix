{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

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
    gh.enable = true;
  };

  home.packages = with pkgs; [
    expect
    git
    gh
    imagemagick
    neofetch
    pandoc
    unzip
    xidel

    # Applications
    google-chrome
    gnome.nautilus

    # Fonts
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })
    source-code-pro

    # Networking
    avahi
    dig
    inetutils
    sshpass
    tcptraceroute
    wget
  ];
}
