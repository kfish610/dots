{ lib, pkgs, config, modulesPath, ... }:

{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "kfish";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  system.stateVersion = "22.11";
}
