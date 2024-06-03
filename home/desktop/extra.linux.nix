{ pkgs, ... }:

{
  home.packages = [
    pkgs.pavucontrol
    pkgs.brightnessctl
    # Set up a polkit agent for GUI apps
    pkgs.polkit_gnome
  ];

  gtk = rec {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = theme;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };



  services = {
    avizo.enable = true;
    mako.enable = true;

    swayidle = {
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
  };

  programs = {
    swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        ignore-empty-password = true;
        scaling = "fill";
        image = "~/.config/background/bg.png";
      };
    };

    kitty = {
      enable = true;
      settings = {
        background_opacity = "0.8";
        background = "#101010";
      };
    };
  };
}
