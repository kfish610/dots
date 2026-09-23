{ config, ... }:

let
  inherit (config.lib.session) lock monitors;
in
{
  services.swayidle.timeouts = [
    {
      timeout = 600;
      command = "${lock} -f";
    }
    {
      timeout = 660;
      command = monitors.off;
      resumeCommand = monitors.on;
    }
  ];
}
