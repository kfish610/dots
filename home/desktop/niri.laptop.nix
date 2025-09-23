{ pkgs, config, ... }:

{
  programs.niri.settings = {
    outputs = {
      "eDP-1".scale = 1;
    };

    spawn-at-startup =
      let
        lock = "${config.programs.swaylock.package}/bin/swaylock";
        eww = "${config.programs.eww.package}/bin/eww";
      in
      [
        {
          argv = [
            "${pkgs.rot8}/bin/rot8"
            "-k"
          ];
        }
        {
          sh = "${lock}; ${eww} daemon && ${eww} open bar";
        }
      ];
  };
}
