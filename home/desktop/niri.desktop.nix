{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (config.lib.niri)
    lock
    niri
    outputs
    windowRules
    matches
    ;

  stack-side-monitor = pkgs.writeShellApplication {
    name = "stack-side-monitor";

    runtimeInputs = [
      config.wayland.windowManager.niri.package
      pkgs.jq
    ];

    text = ''
      win() { niri msg --json windows | jq -r "first(.[] | select($1) | .id) // empty"; }

      discord='.app_id == "discord" and .title != "Discord Updater"'
      chrome='.app_id == "google-chrome"'

      until [[ $(win "$discord") && $(win "$chrome") ]]; do sleep 1; done

      # Pulling Discord's column to the front first means the consume behaves the
      # same whichever of the two mapped earlier.
      niri msg action focus-window --id "$(win "$discord")"
      niri msg action move-column-to-first

      # Pull Chrome into discord
      niri msg action consume-window-into-column
    '';
  };
in
{
  services.swayidle.timeouts = [
    {
      timeout = 600;
      command = "${lock} -f";
    }
    {
      timeout = 660;
      command = "${niri} msg action power-off-monitors";
      resumeCommand = "${niri} msg action power-on-monitors";
    }
  ];

  wayland.windowManager.niri.settings._children =
    outputs {
      "DP-2".mode = "2560x1440@180.000";
      "DP-4" = {
        mode = "1920x1080@165.003";
        transform = "270";
        variable-refresh-rate = { };
      };
    }
    ++ windowRules [
      {
        _children = matches [
          {
            app-id = "^google-chrome$";
            at-startup = true;
          }
          {
            app-id = "^discord$";
            at-startup = true;
          }
        ];

        open-maximized = true;
        open-on-output = "DP-4";
      }
    ];

  home.packages = [ stack-side-monitor ];

  autostart.stack-side-monitor = {
    description = "Stack Discord above Chrome on the side monitor";
    command = [ (lib.getExe stack-side-monitor) ];

    after = [
      "discord"
      "google-chrome"
    ];

    timeout = 120;
  };
}
