{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    musescore
    vscode
    gparted
    discord

    # Fonts
    dejavu_fonts
    (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })
    source-code-pro
  ];

  # programs.discocss = {
  #   enable = true;
  # };
}
