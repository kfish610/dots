{ ... }:

{
  programs.dankMaterialShell = {
    enable = true;
    default.settings = {
      currentThemeName = "blue";
      dankBarTransparency = 0.95;
      dankBarWidgetTransparency = 1;
      popupTransparency = 1;
      dockTransparency = 1;

      use24HourClock = false;
      useFahrenheit = true;
      nightModeEnabled = false;

      useAutoLocation = true;
      weatherEnabled = true;

      selectedGpuIndex = 0;
      enabledGpuPciIds = [ ];

      controlCenterShowNetworkIcon = true;
      controlCenterShowBluetoothIcon = true;
      controlCenterShowAudioIcon = true;
      controlCenterWidgets = [
        {
          id = "brightnessSlider";
          enabled = true;
          width = 10;
        }
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

      showWorkspaceIndex = true;
      showWorkspacePadding = false;
      workspacesPerMonitor = true;

      waveProgressEnabled = true;

      clockDateFormat = "ddd MMM d";

      dankBarLeftWidgets = [
        {
          id = "workspaceSwitcher";
          enabled = true;
        }
        {
          id = "focusedWindow";
          enabled = true;
        }
      ];
      dankBarCenterWidgets = [
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
      dankBarRightWidgets = [
        {
          id = "systemTray";
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
        {
          id = "battery";
          enabled = true;
        }
        {
          id = "cpuUsage";
          enabled = true;
        }
        {
          id = "memUsage";
          enabled = true;
        }
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
          id = "vpn";
          enabled = true;
        }
        {
          id = "controlCenterButton";
          enabled = true;
        }
      ];

      appLauncherViewMode = "list";

      networkPreference = "auto";

      fontFamily = "Inter Variable";
      monoFontFamily = "Fira Code";
      fontWeight = 400;
      fontScale = 1;
      dankBarFontScale = 1;

      showDock = false;

      cornerRadius = 16;

      dankBarAutoHide = false;
      dankBarOpenOnOverview = false;
      dankBarVisible = true;

      dankBarSpacing = 0;
      dankBarBottomGap = 0;
      dankBarInnerPadding = 10;
      dankBarSquareCorners = true;
      dankBarNoBackground = false;
      dankBarGothCornersEnabled = true;
      dankBarBorderEnabled = false;
      dankBarBorderColor = "surfaceText";
      dankBarBorderOpacity = 1;
      dankBarBorderThickness = 1;
      dankBarPosition = 0;

      widgetBackgroundColor = "sth";
      surfaceBase = "sc";

      notificationTimeoutLow = 5000;
      notificationTimeoutNormal = 5000;
      notificationTimeoutCritical = 0;
      notificationPopupPosition = 0;

      osdAlwaysShowValue = true;

      screenPreferences = {
        wallpaper = [ ];
        notepad = [ ];
        dock = [ ];
      };
    };
  };
}
