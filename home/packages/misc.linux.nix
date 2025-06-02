{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    discord
    gparted
    # musescore
    openconnect
    remmina
    slack
    sway-contrib.grimshot
    vscode
    zoom-us
    # postman
    teams-for-linux
    networkmanager-openconnect

    godot_4
    gimp

    rnote

    obsidian

    # nix store add --hash-algo sha256 --mode flat ~/Downloads/Wonderdraft-1.1.8.2b-Linux64.deb
    wonderdraft

    # Fonts
    dejavu_fonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.sauce-code-pro
    source-code-pro
    material-design-icons
    font-awesome
  ];

  # programs.discocss = {
  #   enable = true;
  # };
}
