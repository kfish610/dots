{ pkgs, ... }:

{
  home.packages = with pkgs; [
    musescore
    vscode
  ];
}
