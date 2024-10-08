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
    postman
    teams-for-linux
    networkmanager-openconnect

    godot_4
    gimp

    rnote

    # Fonts
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "SourceCodePro" ]; })
    source-code-pro
    material-design-icons
    font-awesome
  ];

  # programs.discocss = {
  #   enable = true;
  # };
}
