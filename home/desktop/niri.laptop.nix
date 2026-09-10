{ pkgs, ... }:

{
  wayland.windowManager.niri.settings._children = [
    {
      output = {
        _args = [ "eDP-1" ];
        scale = 1;
      };
    }

    {
      spawn-at-startup._args = [
        "${pkgs.rot8}/bin/rot8"
        "-k"
      ];
    }
  ];
}
