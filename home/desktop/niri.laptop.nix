{ pkgs, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    {
      argv = [
        "${pkgs.rot8}/bin/rot8"
        "-k"
      ];
    }
  ];
}
