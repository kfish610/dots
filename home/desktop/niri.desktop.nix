{ config, ... }:

let
  inherit (config.lib.niri)
    lock
    niri
    outputs
    windowRules
    matches
    ;
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
            app-id = "Google-chrome";
            at-startup = true;
          }
          {
            app-id = "discord";
            at-startup = true;
          }
        ];

        open-maximized = true;
        open-on-output = "DP-4";
      }
    ];
}
