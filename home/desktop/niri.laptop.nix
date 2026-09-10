{
  pkgs,
  config,
  ...
}:

let
  inherit (config.lib.niri)
    lock
    niri
    outputs
    spawnAtStartup
    ;
in
{
  services.swayidle.timeouts = [
    {
      timeout = 300;
      command = "${lock} -f";
    }
    {
      timeout = 330;
      command = "${niri} msg action power-off-monitors";
      resumeCommand = "${niri} msg action power-on-monitors";
    }
    {
      timeout = 1800;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }
  ];

  wayland.windowManager.niri.settings._children =
    outputs { "eDP-1".scale = 1; } ++ spawnAtStartup [ [ "${pkgs.rot8}/bin/rot8" ] ];
}
