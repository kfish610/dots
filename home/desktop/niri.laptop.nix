{ config, ... }:

let
  inherit (config.lib.niri) outputs;
in
{
  wayland.windowManager.niri.settings._children = outputs { "eDP-1".scale = 1; };
}
