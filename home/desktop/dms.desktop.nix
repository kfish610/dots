{
  config,
  lib,
  ...
}:

let
  inherit (config.lib.monitors) dmsName;
in
{
  programs.dank-material-shell.bars = {
    default.screenPreferences = lib.mkForce [ (dmsName config.monitors.main) ];

    secondary = {
      name = "Secondary Bar";
      screenPreferences = [ (dmsName config.monitors.side) ];
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
