{
  pkgs,
  config,
  ...
}:

let
  lock = "${config.programs.swaylock.package}/bin/swaylock";
  niri = "${config.wayland.windowManager.niri.package}/bin/niri";
in
{
  services.swayidle.timeouts = [
    {
      timeout = 300;
      command = lock;
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

  wayland.windowManager.niri.settings._children = [
    {
      output = {
        _args = [ "eDP-1" ];
        scale = 1;
      };
    }

    {
      spawn-at-startup._args = [ "${pkgs.rot8}/bin/rot8" ];
    }
  ];
}
