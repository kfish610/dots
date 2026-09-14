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

  # rot8 polls the accelerometer and rotates the screen to match. As a
  # spawn-at-startup entry it raced the compositor it needs to talk to and sent
  # anything it had to say to /dev/null; as a unit it waits for the session and
  # comes back if it dies, instead of staying dead silently until the next boot.
  autostart.rot8 = {
    description = "Screen rotation daemon";
    command = [ "${pkgs.rot8}/bin/rot8" ];
    restart = true;
  };

  wayland.windowManager.niri.settings._children = outputs { "eDP-1".scale = 1; };
}
