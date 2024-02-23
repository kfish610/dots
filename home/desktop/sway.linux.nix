{ pkgs, config, lib, ... }:

{
  gtk = rec {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = theme;
  };

  home.file.".config/background/bg.png".source = ./CelesteCh8.png;

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    config = {
      assigns = {
        "10" = [{ class = "discord"; }];
      };
      defaultWorkspace = "workspace number 1";
      gaps = {
        inner = 10;
        outer = 7;
      };
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+s" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
        };
      output = {
        "*".bg = "~/.config/background/bg.png fill";
      };
      startup = [
        { command = "${pkgs.swaylock}/bin/swaylock"; always = true; }
        { command = "${pkgs.discord}/bin/discord"; }
        { command = "${pkgs.kitty}/bin/kitty"; }
      ];
      terminal = "${pkgs.kitty}/bin/kitty";
      window = {
        border = 0;
        commands = [
          {
            command = "corner_radius 10";
            criteria = {
              app_id = ".*";
              title = ".*";
              class = ".*";
            };
          }
          {
            command = "blur enable";
            criteria = {
              app_id = "kitty";
            };
          }
        ];
      };
    };
  };
}
