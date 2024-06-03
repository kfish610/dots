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
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "SourceCodePro" ]; })
    source-code-pro
    font-awesome
  ];

  # programs.discocss = {
  #   enable = true;
  # };
}
