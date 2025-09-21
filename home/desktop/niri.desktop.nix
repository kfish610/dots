{ ... }:

{
  programs.niri.settings.outputs = {
    "DP-2".mode = {
      width = 2560;
      height = 1440;
      refresh = 180.000;
    };
    "DP-4" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 165.003;
      };
      transform.rotation = 270;
      variable-refresh-rate = true;
    };
  };
}
