{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Applications
    google-chrome
    nautilus
    ollama
    llama-cpp-vulkan

    # Tools
    fastfetch
    graphviz
    imagemagick
    jq
    ncdu
    nix-index
    pandoc
    unzip
    xidel

    # Networking
    avahi
    dig
    traceroute
    tcptraceroute
    wget
  ];
}
