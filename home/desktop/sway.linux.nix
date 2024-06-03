{ pkgs, config, lib, ... }:

{
  home.file.".config/background/bg.png".source = ./CelesteCh8.png;

  wayland.windowManager.sway = {
    enable = true;
    # Fix until nix-community/home-manager#5379 is resolved.
    checkConfig = false;
    package = pkgs.swayfx;
    config = {
      assigns = {
        "10" = [{ class = "discord"; }];
      };
      bars = [ ];
      defaultWorkspace = "workspace number 1";
      fonts = {
        names = [ "FiraMono Nerd Font Mono" ];
        size = 10.0;
      };
      gaps = {
        inner = 10;
        outer = 7;
      };
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will shut down the computer.' -b 'Yes, exit sway' 'systemctl poweroff'";

          "${modifier}+Shift+s" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";

          "XF86MonBrightnessUp" = "exec ${config.services.avizo.package}/bin/lightctl up";
          "XF86MonBrightnessDown" = "exec ${config.services.avizo.package}/bin/lightctl down";

          "XF86AudioRaiseVolume" = "exec ${config.services.avizo.package}/bin/volumectl -u up";
          "XF86AudioLowerVolume" = "exec ${config.services.avizo.package}/bin/volumectl -u down";
          "XF86AudioMute" = "exec ${config.services.avizo.package}/bin/volumectl toggle-mute";
          "XF86AudioMicMute" = "exec ${config.services.avizo.package}/bin/volumectl -m toggle-mute";
        };
      output = {
        "*".bg = "~/.config/background/bg.png fill";
      };
      startup = [
        { command = "${config.programs.swaylock.package}/bin/swaylock"; always = true; }
        { command = "sh -c 'pkill yambar; ${config.programs.yambar.package}/bin/yambar &'"; always = true; }
        { command = "${pkgs.discord}/bin/discord"; }
        { command = "${config.programs.kitty.package}/bin/kitty"; }
      ];
      terminal = "${config.programs.kitty.package}/bin/kitty";
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
