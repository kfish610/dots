{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (config.lib.session) lock monitors chrome;
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
      command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
    }
  ];

  autostart.rot8 = {
    description = "Screen rotation daemon";
    command = [ (lib.getExe pkgs.rot8) ];
    restart = true;
  };

  autostart.google-chrome-work.command = lib.mkForce [
    chrome
    "--profile-directory=Profile 5"
  ];
}
