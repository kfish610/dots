{
  pkgs,
  config,
  lib,
  ...
}:

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

  programs.niri.settings =
    let
      terminal = "${config.programs.kitty.package}/bin/kitty";
      lock = "${config.programs.swaylock.package}/bin/swaylock";
      workspaces = lib.range 1 10;
    in
    {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;

      input = {
        mod-key = "Alt";
        mod-key-nested = "Super";
      };

      layout = {
        gaps = 15;

        border.enable = false;
        focus-ring = with config.lib.stylix.colors.withHashtag; {
          enable = true;
          active.color = base0D;
          urgent.color = base0F;
          inactive = null;
        };
      };

      window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius = lib.genAttrs [
            "bottom-left"
            "bottom-right"
            "top-left"
            "top-right"
          ] (_: 10.0);
        }
      ];

      spawn-at-startup =
        let
          lock = "${config.programs.swaylock.package}/bin/swaylock";
        in
        [
          { argv = [ lock ]; }
          { argv = [ "${pkgs.discord}/bin/discord" ]; }
          {
            argv = [
              "${pkgs.google-chrome}/bin/google-chrome-stable"
              "--profile-directory=Default"
            ];
          }
          {
            argv = [
              "wpaperd"
              "-d"
            ];
          }
          {
            argv = [
              "dms"
              "run"
            ];
          }
        ];

      binds =
        with config.lib.niri.actions;
        let
          dms-ipc = spawn "dms" "ipc";
        in
        {
          "Mod+Left".action = focus-column-or-monitor-left;
          "Mod+Right".action = focus-column-or-monitor-right;
          "Mod+Up".action = focus-window-or-workspace-up;
          "Mod+Down".action = focus-window-or-workspace-down;

          "Mod+Shift+Left".action = move-column-left-or-to-monitor-left;
          "Mod+Shift+Right".action = move-column-right-or-to-monitor-right;
          "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;

          "Mod+Ctrl+Left".action = focus-monitor-left;
          "Mod+Ctrl+Right".action = focus-monitor-right;
          "Mod+Ctrl+Up".action = focus-workspace-up;
          "Mod+Ctrl+Down".action = focus-workspace-down;

          "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
          "Mod+Shift+Ctrl+Up".action = move-column-to-workspace-up;
          "Mod+Shift+Ctrl+Down".action = move-column-to-workspace-down;

          "Mod+Comma".action = consume-or-expel-window-left;
          "Mod+Period".action = consume-or-expel-window-right;

          "Mod+A".action = set-column-width "${toString (1. / 3. * 100)}%";
          "Mod+S".action = set-column-width "${toString (1. / 2. * 100)}%";
          "Mod+D".action = set-column-width "${toString (2. / 3. * 100)}%";
          "Mod+F".action = maximize-column;

          "Mod+Shift+A".action = set-window-height "${toString (1. / 3. * 100)}%";
          "Mod+Shift+S".action = set-window-height "${toString (1. / 2. * 100)}%";
          "Mod+Shift+D".action = set-window-height "${toString (2. / 3. * 100)}%";
          "Mod+Shift+F".action = fullscreen-window;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+Tab".action = toggle-overview;
          "Mod+Shift+Space".action = toggle-window-floating;

          "Mod+Shift+Q".action = close-window;
          "Mod+Shift+E".action = dms-ipc "powermenu" "toggle"; # open power menu

          "Mod+Space".action = dms-ipc "spotlight" "toggle"; # open app menu
          "Mod+Return".action = spawn terminal;
          "Mod+L".action = spawn lock;
          "Print".action.screenshot = [ ];

          "XF86AudioMute".action = dms-ipc "audio" "mute";
          "XF86AudioMicMute".action = dms-ipc "audio" "micmute";
          "XF86AudioRaiseVolume".action = dms-ipc "audio" "increment" "3";
          "XF86AudioLowerVolume".action = dms-ipc "audio" "decrement" "3";

          "XF86MonBrightnessUp".action = dms-ipc "brightness" "increment" "5" "";
          "XF86MonBrightnessDown".action = dms-ipc "brightness" "decrement" "5" "";
        }
        // lib.foldl' (
          acc: x:
          {
            "Mod+${toString (lib.mod x 10)}".action.focus-workspace = x;
            "Mod+Shift+${toString (lib.mod x 10)}".action.move-column-to-workspace = x;
          }
          // acc
        ) { } workspaces;
    };
}
