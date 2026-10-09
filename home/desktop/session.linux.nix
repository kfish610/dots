{
  pkgs,
  config,
  lib,
  ...
}:

let
  lock = "${config.programs.swaylock.package}/bin/swaylock";
  chrome = "${pkgs.google-chrome}/bin/google-chrome-stable";

  wait-for-tray = pkgs.writeShellApplication {
    name = "wait-for-tray";
    runtimeInputs = [ pkgs.glib ];

    text = "gdbus wait --session --timeout 30 org.kde.StatusNotifierWatcher";
  };
in
{
  lib.session = { inherit lock chrome; };

  # Prefer Wayland for Qt apps, falling back to X11 for ones without the plugin (e.g. the Android emulator)
  programs.zsh.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";

  home.packages = with pkgs; [
    brightnessctl
    networkmanagerapplet
    wl-clipboard
  ];

  services.wpaperd.enable = true;

  programs = {
    kitty = {
      enable = true;
      settings.confirm_os_window_close = 0;
    };

    swaylock = {
      enable = true;
      settings.ignore-empty-password = true;
    };
  };

  services.swayidle = {
    enable = true;

    events = {
      before-sleep = lock;
      lock = "${lock} -f";
    };
  };

  autostart = {
    wait-for-tray = {
      description = "Wait for the system tray to accept registrations";
      command = [ (lib.getExe wait-for-tray) ];

      after = [ "dms" ];
      timeout = 35;
    };

    discord = {
      command = [ "${pkgs.discord}/bin/discord" ];
      window = ''.app_id == "discord" and .title != "Discord Updater"'';
      after = [ "wait-for-tray" ];
    };

    slack = {
      command = [ "${pkgs.slack}/bin/slack" ];
      window = ''.app_id == "slack"'';
      after = [ "wait-for-tray" ];
    };

    google-chrome = {
      command = [
        chrome
        "--profile-directory=Default"
      ];
      window = ''.app_id == "google-chrome"'';
    };

    google-chrome-work = {
      command = [
        chrome
        "--profile-directory=Profile 1"
      ];
      window = ''.app_id == "google-chrome"'';
      after = [ "google-chrome" ];
    };
  };
}
