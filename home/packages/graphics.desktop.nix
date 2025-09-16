{ pkgs, ... }:

{
  home.packages = with pkgs; [
    intel-gpu-tools
  ];
}
