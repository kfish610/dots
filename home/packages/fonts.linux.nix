{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    dejavu_fonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.sauce-code-pro
    source-code-pro
    material-design-icons
    font-awesome
    noto-fonts
  ];
}
