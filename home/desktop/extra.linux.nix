{ pkgs, config, ... }:

{
  gtk = rec {
    enable = true;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
    iconTheme = theme;
    cursorTheme = theme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  services.mako.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
      background = "#101010";
      font_family = config.constants.sway.code_font;
    };
  };
}
