{ ... }:

{
  imports = [ ./base.nix ];

  networking.hostName = "wsl";

  wsl = {
    enable = true;
    defaultUser = "kfish";
    startMenuLaunchers = true;
    docker-desktop.enable = true;
  };
}
