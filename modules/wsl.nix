{ nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "wsl";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "kfish";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };
}
