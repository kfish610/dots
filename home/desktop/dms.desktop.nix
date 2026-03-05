{ lib, ... }:

{
  programs.dank-material-shell.bars = {
    default.screenPreferences = lib.mkForce [ "DP-2" ];

    secondary = {
      name = "Secondary Bar";
      screenPreferences = [ "DP-4" ];
      leftWidgets = [
        {
          id = "workspaceSwitcher";
          enabled = true;
        }
      ];
      centerWidgets = [
        {
          id = "clock";
          enabled = true;
          clockCompactMode = true;
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
        {
          id = "controlCenterButton";
          enabled = true;
        }
      ];
    };
  };
}
