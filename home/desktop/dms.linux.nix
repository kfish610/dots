{
  lib,
  config,
  systemInfo,
  ...
}:

{
  options.programs.dank-material-shell = {
    bars = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = { };
      description = "Better format for bars that gets compiled into the actual expected representation.";
    };

    barStyle = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Bar styling";
    };
  };

  config.programs.dank-material-shell = {
    enable = true;

    # khal currently doesn't build, and I don't use this anyway.
    enableCalendarEvents = false;

    barStyle = {
      autoHide = false;
      openOnOverview = false;
      transparency = 0.95;
      widgetTransparency = 1;
      spacing = 0;
      bottomGap = 0;
      innerPadding = 10;
      squareCorners = true;
      noBackground = false;
      gothCornersEnabled = true;
      position = 0;
    };

    bars.default = {
      name = "Main Bar";
      screenPreferences = [ "all" ];
      leftWidgets = [
        {
          id = "workspaceSwitcher";
          enabled = true;
        }
        {
          id = "focusedWindow";
          enabled = true;
        }
      ];
      centerWidgets = [
        {
          id = "music";
          enabled = true;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "weather";
          enabled = true;
        }
      ];
      rightWidgets = [
        {
          id = "colorPicker";
          enabled = true;
        }
        {
          id = "clipboard";
          enabled = true;
        }
        {
          id = "notificationButton";
          enabled = true;
        }
      ]
      ++ (
        if builtins.elem "laptop" systemInfo then
          [
            {
              id = "battery";
              enabled = true;
            }
          ]
        else
          [ ]
      )
      ++ [
        {
          id = "cpuUsage";
          enabled = true;
        }
        {
          id = "memUsage";
          enabled = true;
        }
      ]
      ++ (
        if builtins.elem "desktop" systemInfo then
          [
            {
              id = "gpuTemp";
              enabled = true;
              selectedGpuIndex = 1;
            }
          ]
        else
          [ ]
      )
      ++ [
        {
          id = "cpuTemp";
          enabled = true;
        }
        {
          id = "diskUsage";
          enabled = true;
        }
        {
          id = "privacyIndicator";
          enabled = true;
        }
        {
          id = "systemTray";
          enabled = true;
        }
        {
          id = "controlCenterButton";
          enabled = true;
        }
      ];
    };

    settings = {
      # Disable unwanted features
      runUserMatugenTemplates = false;
      runDmsMatugenTemplates = false;
      nightModeEnabled = false;
      showDock = false;
      screenPreferences = {
        wallpaper = [ ];
        notepad = [ ];
        dock = [ ];
      };

      # Styling
      fontWeight = 400;
      fontScale = 1;
      cornerRadius = 16;
      surfaceBase = "sc";
      osdAlwaysShowValue = true;
      widgetBackgroundColor = "sth";

      # Notifications
      notificationTimeoutLow = 5000;
      notificationTimeoutNormal = 5000;
      notificationTimeoutCritical = 0;
      notificationPopupPosition = 0;

      # Launcher
      appLauncherViewMode = "list";

      # Generate bars
      barConfigs = lib.mapAttrsToList (
        id: conf:
        conf
        // config.programs.dank-material-shell.barStyle
        // {
          id = id;
          enabled = true;
        }
      ) config.programs.dank-material-shell.bars;

      # Workspace settings
      showWorkspaceIndex = true;
      showWorkspacePadding = false;
      workspacesPerMonitor = true;

      # Music settings
      audioScrollMode = "song";
      waveProgressEnabled = true;

      # Clock settings
      use24HourClock = false;
      clockDateFormat = "ddd MMM d";

      # Weather settings
      weatherEnabled = true;
      useAutoLocation = true;
      useFahrenheit = true;

      # Performance monitoring settings
      selectedGpuIndex = 1;

      # Control Center settings
      networkPreference = "auto";
      controlCenterShowNetworkIcon = true;
      controlCenterShowBluetoothIcon = true;
      controlCenterShowAudioIcon = true;
      controlCenterWidgets =
        (
          if builtins.elem "laptop" systemInfo then
            [
              {
                id = "brightnessSlider";
                enabled = true;
                width = 100;
              }
            ]
          else
            [ ]
        )
        ++ [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "inputVolumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "audioInput";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "bluetooth";
            enabled = true;
            width = 50;
          }
          {
            id = "builtin_vpn";
            enabled = true;
            width = 50;
          }
          {
            id = "battery";
            enabled = true;
            width = 50;
          }
          {
            id = "doNotDisturb";
            enabled = true;
            width = 25;
          }
          {
            id = "idleInhibitor";
            enabled = true;
            width = 25;
          }
          {
            id = "darkMode";
            enabled = true;
            width = 25;
          }
          {
            id = "nightMode";
            enabled = true;
            width = 25;
          }
        ];
    };
  };
}
