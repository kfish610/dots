{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    discord
    gparted
    # musescore
    openconnect
    slack
    sway-contrib.grimshot
    vscode
    zoom-us

    # Fonts
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })
    source-code-pro
  ];

  # programs.discocss = {
  #   enable = true;
  # };
}
