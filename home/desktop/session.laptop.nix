{ pkgs, config, ... }:

let
  inherit (config.lib.session) lock monitors;
in
{
  services.swayidle.timeouts = [
    {
      timeout = 300;
      command = "${lock} -f";
    }
    {
      timeout = 330;
      command = monitors.off;
      resumeCommand = monitors.on;
    }
    {
      timeout = 1800;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }
  ];

  autostart.rot8 = {
    description = "Screen rotation daemon";
    command = [ "${pkgs.rot8}/bin/rot8" ];
    restart = true;
  };
}
