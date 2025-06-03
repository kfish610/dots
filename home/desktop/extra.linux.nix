{ pkgs, config, ... }:

{
  services.mako.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
    };
  };

  programs.eww = {
    enable = true;
    configDir = ./eww;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
    };
  };
}
