{ lib, ... }:

{
  options.constants.sway =
    let
      mkConst =
        value:
        lib.mkOption {
          type = lib.types.str;
          default = value;
        };
    in
    {
      disp_font = mkConst "FiraMono Nerd Font Mono";
      code_font = mkConst "FiraCode Nerd Font Mono";

      exit_cmd = mkConst "swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will shut down the computer.' -b 'Yes, exit sway' 'systemctl poweroff'";
      restart_cmd = mkConst "swaynag -t warning -m 'You pressed the restart shortcut. Do you really want to restart sway? This will reboot the computer.' -b 'Yes, restart sway' 'systemctl reboot'";
    };
}
