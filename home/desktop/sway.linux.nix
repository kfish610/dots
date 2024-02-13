{ pkgs, ... }:

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
