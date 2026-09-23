{
  pkgs,
  config,
  lib,
  ...
}:

let
  lock = "${config.programs.swaylock.package}/bin/swaylock";

  wait-for-tray = pkgs.writeShellApplication {
    name = "wait-for-tray";
    runtimeInputs = [ pkgs.glib ];

    text = "gdbus wait --session --timeout 30 org.kde.StatusNotifierWatcher";
  };
in
{
  lib.session = { inherit lock; };

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
      after = [ "wait-for-tray" ];
    };

    google-chrome.command = [
      "${pkgs.google-chrome}/bin/google-chrome-stable"
      "--profile-directory=Default"
    ];
  };
}
