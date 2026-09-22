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

  inherit (config.lib.monitors) niriName;

  main-monitor = niriName config.monitors.main;
  side-monitor = niriName config.monitors.side;

  stack-side-monitor = pkgs.writeShellApplication {
    name = "stack-side-monitor";

    runtimeInputs = [
      config.wayland.windowManager.niri.package
      pkgs.jq
      pkgs.procps
    ];

    text = ''
      win() { niri msg --json windows | jq -r "first(.[] | select($1) | .id) // empty"; }

      discord='.app_id == "discord" and .title != "Discord Updater"'
      chrome='.app_id == "google-chrome"'

      until [[ $(win "$discord") && $(win "$chrome") ]]; do sleep 1; done

      while pgrep swaylock >/dev/null; do sleep 1; done

      d=$(win "$discord")
      c=$(win "$chrome")

      niri msg action focus-window --id "$d"
      niri msg action move-column-to-first
      niri msg action focus-window --id "$c"
      niri msg action move-column-to-index 2
      niri msg action focus-window --id "$d"
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
      ${main-monitor}.mode = "2560x1440@180.000";
      ${side-monitor} = {
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
        open-on-output = side-monitor;
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
  };
}
