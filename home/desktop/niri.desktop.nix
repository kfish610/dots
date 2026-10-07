{
  config,
  ...
}:

let
  inherit (config.lib.niri) outputs;

  inherit (config.lib.monitors) niriName;

  main-monitor = niriName config.monitors.main;
  side-monitor = niriName config.monitors.side;
in
{
  wayland.windowManager.niri.settings._children = outputs {
    ${main-monitor} = {
      mode = "2560x1440@180.000";
      variable-refresh-rate = { };
    };
    ${side-monitor} = {
      mode = "1920x1080@120.000";
      transform = "270";
    };
  };

  workspaces = [
    {
      name = "personal";
      output = side-monitor;
      columns = [
        [
          "discord"
          "google-chrome"
        ]
      ];
    }
    {
      name = "work";
      output = side-monitor;
      columns = [
        [
          "slack"
          "google-chrome-work"
        ]
      ];
    }
  ];
}
