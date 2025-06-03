{ pkgs, config, ... }:

{
  home = {
    packages = with pkgs; [
      hyprland-workspaces
    ];
  };

  services = {
    hyprpaper.enable = true;
    hyprpolkitagent.enable = true;
    mako.enable = true;
  };

  programs = {
    kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
      };
    };

    eww = {
      enable = true;
      configDir = ./eww;
    };

    swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        ignore-empty-password = true;
      };
    };
  };
}
