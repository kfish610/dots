{
  pkgs,
  config,
  lib,
  ...
}:

let
  lock = "${config.programs.swaylock.package}/bin/swaylock";
in
{
  services.wpaperd.enable = true;

  programs = {
    kitty = {
      enable = true;
      settings.confirm_os_window_close = 0;
    };

    swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        ignore-empty-password = true;
      };
    };
  };

  services.swayidle = {
    enable = true;

    events = {
      before-sleep = lock;
      lock = lock;
    };
  };

  wayland.windowManager.niri = {
    enable = true;
    systemd.enable = false;
    portalPackage = null;
    xwaylandSatellitePackage = null;
  };

  wayland.windowManager.niri.settings =
    let
      terminal = "${config.programs.kitty.package}/bin/kitty";
      workspaces = lib.range 1 10;
    in
    {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      hotkey-overlay.skip-at-startup = { };
      prefer-no-csd = { };

      input = {
        mod-key = "Alt";
        mod-key-nested = "Super";
      };

      layout = {
        gaps = 15;
        default-column-width.proportion = 1.0;

        border.off = { };
        focus-ring = with config.lib.stylix.colors.withHashtag; {
          active-color = base0D;
          urgent-color = base0F;
        };
      };

      _children = [
        {
          window-rule = {
            clip-to-geometry = true;
            geometry-corner-radius = 10.0;
          };
        }
      ]

      ++ map (argv: { spawn-at-startup._args = argv; }) [
        [ lock ]
        [ "${pkgs.discord}/bin/discord" ]
        [
          "${pkgs.google-chrome}/bin/google-chrome-stable"
          "--profile-directory=Default"
        ]
      ];

      binds = {
        "Mod+Left".focus-column-or-monitor-left = { };
        "Mod+Right".focus-column-or-monitor-right = { };
        "Mod+Up".focus-window-or-workspace-up = { };
        "Mod+Down".focus-window-or-workspace-down = { };

        "Mod+Shift+Left".move-column-left-or-to-monitor-left = { };
        "Mod+Shift+Right".move-column-right-or-to-monitor-right = { };
        "Mod+Shift+Up".move-window-up-or-to-workspace-up = { };
        "Mod+Shift+Down".move-window-down-or-to-workspace-down = { };

        "Mod+Ctrl+Left".focus-monitor-left = { };
        "Mod+Ctrl+Right".focus-monitor-right = { };
        "Mod+Ctrl+Up".focus-workspace-up = { };
        "Mod+Ctrl+Down".focus-workspace-down = { };

        "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+Up".move-column-to-workspace-up = { };
        "Mod+Shift+Ctrl+Down".move-column-to-workspace-down = { };

        "Mod+Comma".consume-or-expel-window-left = { };
        "Mod+Period".consume-or-expel-window-right = { };

        "Mod+A".set-column-width = "${toString (1. / 3. * 100)}%";
        "Mod+S".set-column-width = "${toString (1. / 2. * 100)}%";
        "Mod+D".set-column-width = "${toString (2. / 3. * 100)}%";
        "Mod+F".maximize-column = { };

        "Mod+Shift+A".set-window-height = "${toString (1. / 3. * 100)}%";
        "Mod+Shift+S".set-window-height = "${toString (1. / 2. * 100)}%";
        "Mod+Shift+D".set-window-height = "${toString (2. / 3. * 100)}%";
        "Mod+Shift+F".fullscreen-window = { };

        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        "Mod+Tab".toggle-overview = { };
        "Mod+Shift+Space".toggle-window-floating = { };

        "Mod+Shift+Q".close-window = { };
        "Mod+Shift+E".spawn = [
          "dms"
          "ipc"
          "powermenu"
          "toggle"
        ];

        "Mod+Space".spawn = [
          "dms"
          "ipc"
          "spotlight"
          "toggle"
        ]; # open app menu
        "Mod+Return".spawn = [ terminal ];
        "Mod+L".spawn = [ lock ];
        "Print".screenshot = { };
        "Alt+Print".screenshot-window = { };

        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "mute"
          ];
        };
        "XF86AudioMicMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "micmute"
          ];
        };
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "increment"
            "3"
          ];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "decrement"
            "3"
          ];
        };

        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "brightness"
            "increment"
            "5"
            ""
          ];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "brightness"
            "decrement"
            "5"
            ""
          ];
        };
      }
      // lib.foldl' (
        acc: x:
        {
          "Mod+${toString (lib.mod x 10)}".focus-workspace = x;
          "Mod+Shift+${toString (lib.mod x 10)}".move-column-to-workspace = x;
        }
        // acc
      ) { } workspaces;
    };
}
