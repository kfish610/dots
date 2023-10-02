{ ... }:

{
  home.packages = [ pkgs.polkit_gnome ];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "swaylock";
      }
    ];
    timeouts = [
      { timeout = 300; command = "swaylock"; }
      {
        timeout = 270;
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      scaling = "fill";
      image = "~/.config/background/bg.png";
    };
  };

  programs.kitty.enable = true;
}
