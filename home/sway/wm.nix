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
      output = {
        "*".bg = "~/.config/background/bg.png fill";
      };
      startup = [
        { command = "${pkgs.swaylock}/bin/swaylock"; }
      ];
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
}
