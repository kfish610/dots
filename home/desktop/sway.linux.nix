{
  pkgs,
  config,
  lib,
  ...
}:

{
  home = {
    file.".config/background/bg.png".source = ./CelesteCh8.png;

    packages = with pkgs; [
      brightnessctl
      pavucontrol
      polkit_gnome
    ];
  };

  systemd.user = {
    sessionVariables = config.home.sessionVariables;

    services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  services = {
    avizo.enable = true;

    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "swaylock";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "swaylock";
        }
        {
          timeout = 270;
          command = "swaymsg 'output * dpms off'";
          resumeCommand = "swaymsg 'output * dpms on'";
        }
      ];
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      scaling = "fill";
      image = "~/.config/background/bg.png";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    # Fix until nix-community/home-manager#5379 is resolved.
    checkConfig = false;
    package = pkgs.swayfx;
    config = {
      assigns = {
        "10" = [ { class = "discord"; } ];
      };
      bars = [ ];
      defaultWorkspace = "workspace number 1";
      fonts = {
        names = [ config.constants.sway.disp_font ];
        size = 10.0;
      };
      gaps = {
        inner = 10;
        outer = 7;
      };
      input."*".map_to_output = "eDP-1";
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+e" = "exec ${config.constants.sway.exit_cmd}";
          "${modifier}+Shift+r" = "exec ${config.constants.sway.restart_cmd}";

          "${modifier}+Shift+s" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";

          "${modifier}+l" = "exec swaylock";

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
        {
          command = "${config.programs.swaylock.package}/bin/swaylock";
          always = true;
        }
        {
          command = "sh -c 'pkill yambar; ${config.programs.yambar.package}/bin/yambar &'";
          always = true;
        }
        {
          command = "${pkgs.rot8}/bin/rot8 -k ";
          always = true;
        }
        { command = "${pkgs.discord}/bin/discord"; }
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
