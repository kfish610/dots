{ pkgs, ... }:

{
  programs.yambar = {
    enable = true;
    settings = {
      bar =
        let
          awesome = "Font Awesome 6 Free:style=solid:pixelsize=14";
        in
        {
          location = "top";

          height = 32;
          spacing = 12;
          margin = 16;

          font = "FiraMono Nerd Font Mono:pixelsize=16";
          background = "00000066";

          left = [
            {
              i3 = rec {
                persistent = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
                content =
                  let
                    workspace = n: {
                      name = n;
                      value = let s = { text = if n == "10" then "0" else n; margin = 6; }; in {
                        map = {
                          default.string = s;
                          conditions = {
                            empty.string = s // {
                              foreground = "666666ff";
                            };
                            focused.string = s // {
                              deco = {
                                underline = {
                                  size = 2;
                                  color = "ffffffff";
                                };
                              };
                            };
                            urgent.string = s // {
                              deco = {
                                background = {
                                  color = "ff0000ff";
                                };
                              };
                            };
                          };
                        };
                      };
                    };
                  in
                  builtins.listToAttrs (map workspace persistent);
                spacing = 5;
              };
            }
          ];

          center = [
            {
              clock = {
                date-format = "%a, %x";
                content = [
                  { string = { text = ""; font = awesome; }; }
                  { string = { text = " {date}"; }; }
                ];
              };
            }
            {
              clock = {
                time-format = "%r %Z";
                content = [
                  { string = { text = ""; font = awesome; }; }
                  { string = { text = " {time}"; }; }
                ];
              };
            }
          ];

          right = [
            {
              battery = {
                name = "BAT1";
                poll-interval = 30000;

                content =
                  let
                    discharging = [
                      {
                        ramp = {
                          tag = "capacity";
                          items = [
                            { string = { text = ""; foreground = "ff0000ff"; font = awesome; }; }
                            { string = { text = ""; foreground = "ffa600ff"; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; foreground = "00ff00ff"; font = awesome; }; }
                          ];
                        };
                      }
                      {
                        string = { text = " {capacity}% {estimate}"; };
                      }
                    ];
                  in
                  {
                    map = {
                      conditions = {
                        "state == unknown" = discharging;
                        "state == discharging" = discharging;
                        "state == \"not charging\"" = discharging;
                        "state == charging" = [
                          { string = { text = ""; foreground = "00ff00ff"; font = awesome; }; }
                          { string = { text = " {capacity}% {estimate}"; }; }
                        ];
                        "state == full" = [
                          { string = { text = ""; foreground = "00ff00ff"; font = awesome; }; }
                          { string = { text = " {capacity}% full"; }; }
                        ];
                      };
                    };
                  };
              };
            }
          ];
        };
    };
  };
}
