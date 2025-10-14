{ pkgs, ... }:

{
  programs.niri.settings = {
    outputs = {
      "eDP-1".scale = 1;
    };

    spawn-at-startup = [
      {
        argv = [
          "${pkgs.rot8}/bin/rot8"
          "-k"
        ];
      }
    ];
  };
}
