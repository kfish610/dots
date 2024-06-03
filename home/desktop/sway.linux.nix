{ pkgs, config, lib, ... }:

{
  home.packages = [
    pkgs.pavucontrol
    pkgs.brightnessctl
  ];

  gtk = rec {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = theme;
  };

  home.file.".config/background/bg.png".source = ./CelesteCh8.png;

  services = {
    avizo.enable = true;
    mako.enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    # Fix until nix-community/home-manager#5379 is resolved.
    checkConfig = false;
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

          "XF86MonBrightnessUp" = "exec ${pkgs.avizo}/bin/lightctl up";
          "XF86MonBrightnessDown" = "exec ${pkgs.avizo}/bin/lightctl down";

          "XF86AudioRaiseVolume" = "exec ${pkgs.avizo}/bin/volumectl -u up";
          "XF86AudioLowerVolume" = "exec ${pkgs.avizo}/bin/volumectl -u down";
          "XF86AudioMute" = "exec ${pkgs.avizo}/bin/volumectl toggle-mute";
          "XF86AudioMicMute" = "exec ${pkgs.avizo}/bin/volumectl -m toggle-mute";
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
