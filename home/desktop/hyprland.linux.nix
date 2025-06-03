{
  pkgs,
  config,
  lib,
  ...
}:

{
  home = {
    packages = with pkgs; [
      hyprland-workspaces
    ];
  };

  services = {
    hyprpaper.enable = true;
    hyprpolkitagent.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    settings =
      let
        swayosd = "${pkgs.swayosd}/bin";
        terminal = "${pkgs.kitty}/bin/kitty";
        fileManager = "${pkgs.nautilus}/bin/nautilus";
        browser = "${pkgs.google-chrome}/bin/google-chrome-stable";
        menu = "${pkgs.wofi}/bin/wofi";
        lock = "${pkgs.swaylock}/bin/swaylock";
        mod = "ALT";
        directions = [
          "left"
          "right"
          "up"
          "down"
        ];
        workspaces = lib.range 1 10;
      in
      {
        windowrule = [
          "workspace 10, class:discord"
        ];

        debug.disable_logs = false;

        monitor = [
          ", preferred, auto, 1"
        ];

        general = {
          gaps_out = 15;
        };

        decoration = {
          rounding = 10;

          blur = {
            passes = 2;
            size = 5;
          };

          shadow.enabled = false;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_min_fingers = true;
          workspace_swipe_forever = true;
          workspace_swipe_use_r = true;
        };

        group.groupbar.height = 0;

        dwindle = {
          preserve_split = true;
          force_split = 2;
        };

        bindel = [
          ", XF86AudioRaiseVolume, exec, ${swayosd}/swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, ${swayosd}/swayosd-client --output-volume lower"
          ", XF86MonBrightnessUp, exec, ${swayosd}/swayosd-client --brightness raise"
          ", XF86MonBrightnessDown, exec, ${swayosd}/swayosd-client --brightness lower"
        ];

        bindl = [
          ", XF86AudioMute, exec, ${swayosd}/swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${swayosd}/swayosd-client --input-volume mute-toggle"
        ];

        bind =
          [
            "${mod} SHIFT, Q, killactive"
            "${mod} SHIFT, E, exit"
            "${mod}, Space, exec, ${menu} --show drun"
            "${mod}, Return, exec, ${terminal}"
            "${mod}, F, exec, ${fileManager}"
            "${mod}, B, exec, ${browser}"
            "${mod}, L, exec, ${lock}"

            "${mod} SHIFT, Space, togglefloating"
            "${mod}, T, togglesplit"
            "${mod}, G, togglegroup"

            "${mod}, bracketleft, changegroupactive, b"
            "${mod}, bracketright, changegroupactive, f"
          ]
          ++ lib.map (x: "${mod}, ${x}, movefocus, ${lib.substring 0 1 x}") directions
          ++ lib.map (x: "${mod} SHIFT, ${x}, movewindoworgroup, ${lib.substring 0 1 x}") directions
          ++ lib.map (x: "${mod}, ${toString (lib.mod x 10)}, workspace, ${toString x}") workspaces
          ++ lib.map (
            x: "${mod} SHIFT, ${toString (lib.mod x 10)}, movetoworkspace, ${toString x}"
          ) workspaces;

        exec-once = [
          "${lock}; ${config.programs.eww.package}/bin/eww daemon && ${config.programs.eww.package}/bin/eww open bar"
          "${swayosd}/swayosd-server"
          "${pkgs.discord}/bin/discord"
          "${pkgs.rot8}/bin/rot8 -k"
        ];

        exec = [
          "pkill eww; ${config.programs.eww.package}/bin/eww daemon && ${config.programs.eww.package}/bin/eww open bar"
        ];
      };
  };
}
