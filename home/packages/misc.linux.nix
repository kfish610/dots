{ pkgs, ... }:

{
  home.packages = with pkgs; [
    musescore
    vscode
    gparted
    discord
  ];

  # programs.discocss = {
  #   enable = true;
  # };
}
