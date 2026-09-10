{ ... }:

{
  wayland.windowManager.niri.settings._children = [
    {
      output = {
        _args = [ "DP-2" ];
        mode = "2560x1440@180.000";
      };
    }
    {
      output = {
        _args = [ "DP-4" ];
        mode = "1920x1080@165.003";
        transform = "270";
        variable-refresh-rate = { };
      };
    }

    {
      window-rule = {
        _children = [
          {
            match._props = {
              app-id = "Google-chrome";
              at-startup = true;
            };
          }
          {
            match._props = {
              app-id = "discord";
              at-startup = true;
            };
          }
        ];

        open-maximized = true;
        open-on-output = "DP-4";
      };
    }
  ];
}
