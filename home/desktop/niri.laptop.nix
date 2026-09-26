{ config, ... }:

let
  inherit (config.lib.niri) outputs;
in
{
  wayland.windowManager.niri.settings._children = outputs { "eDP-1".scale = 1; };

  workspaces = [
    {
      name = "personal";
      output = "eDP-1";
      columns = [
        [ "google-chrome" ]
        [ "discord" ]
      ];
    }
    {
      name = "work";
      output = "eDP-1";
      columns = [
        [ "google-chrome-work" ]
        [ "slack" ]
      ];
    }
  ];
}
