{
  pkgs,
  config,
  lib,
  ...
}:

{
  services = {
    mako.enable = true;
    wpaperd.enable = true;
  };

  programs = {
    fuzzel.enable = true;

    eww = {
      enable = true;
      configDir = ./eww;
    };

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
      swayosd = "${pkgs.swayosd}/bin";
      terminal = "${config.programs.kitty.package}/bin/kitty";
      menu = "${config.programs.fuzzel.package}/bin/fuzzel";
      lock = "${config.programs.swaylock.package}/bin/swaylock";
      eww = "${config.programs.eww.package}/bin/eww";
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

      layout = rec {
        gaps = 15;

        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];

        preset-window-heights = preset-column-widths;

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

      spawn-at-startup = [
        {
          sh = "${lock}; ${eww} daemon && ${eww} open bar";
        }
        { argv = [ "${swayosd}/swayosd-server" ]; }
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
      ];

      binds =
        with config.lib.niri.actions;
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

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+D".action = switch-preset-column-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+Tab".action = toggle-overview;
          "Mod+Shift+Space".action = toggle-window-floating;

          "Mod+Shift+Q".action = close-window;
          "Mod+Shift+E".action = quit;

          "Mod+Space".action = spawn menu;
          "Mod+Return".action = spawn terminal;
          "Mod+L".action = spawn lock;
          "Mod+Shift+S".action = screenshot;

          "XF86AudioMute".action = spawn "${swayosd}/swayosd-client" "--output-volume" "mute-toggle";
          "XF86AudioMicMute".action = spawn "${swayosd}/swayosd-client" "--input-volume" "mute-toggle";
          "XF86AudioRaiseVolume".action = spawn "${swayosd}/swayosd-client" "--output-volume" "raise";
          "XF86AudioLowerVolume".action = spawn "${swayosd}/swayosd-client" "--output-volume" "lower";

          "XF86MonBrightnessUp".action = spawn "${swayosd}/swayosd-client" "--brightness" "raise";
          "XF86MonBrightnessDown".action = spawn "${swayosd}/swayosd-client" "--brightness" "lower";
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
