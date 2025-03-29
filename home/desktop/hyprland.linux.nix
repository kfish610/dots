{
  pkgs,
  config,
  lib,
  ...
}:

{
  home = {
    sessionVariables.NIXOS_OZONE_WL = "1";

    # packages = with pkgs; [

    # ];
  };

  services.swayosd = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    settings =
      let
        swayosd = "${config.services.swayosd.package}/bin";
      in
      {
        exec-once = [
          "${swayosd}/swayosd-server"
        ];
        bind = [
          ", XF86AudioMute, exec, ${swayosd}/swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${swayosd}/swayosd-client --input-volume mute-toggle"
        ];
        binde = [
          ", XF86AudioRaiseVolume, exec, ${swayosd}/swayosd-client --output-volume raise"
          ", XF86AudioRaiseVolume, exec, ${swayosd}/swayosd-client --output-volume lower"
          ", XF86MonBrightnessUp, exec, ${swayosd}/swayosd-client --brightness up"
          ", XF86MonBrightnessDown, exec, ${swayosd}/swayosd-client --brightness down"
        ];
      };
  };
}
