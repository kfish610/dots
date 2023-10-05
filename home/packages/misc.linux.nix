{ pkgs, ... }:

{
  home.packages = with pkgs; [
    musescore
    vscode
    gparted
  ];

  programs.discocss = {
    enable = true;
  };
}
