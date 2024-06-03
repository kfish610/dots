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

          height = 26;
          spacing = 10;
          margin = 15;

          font = "Adobe Helvetica:pixelsize=12";
          background = "00000066";

          left = [
            {
              i3 = rec {
                persistent = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
                content =
                  let
                    workspace = n: {
                      name = n;
                      value = {
                        map = {
                          default.string = {
                            text = if n == "10" then "0" else n;
                            margin = 5;
                          };
                          conditions = {
                            focused.string = {
                              text = if n == "10" then "0" else n;
                              margin = 5;
                              deco = {
                                underline = {
                                  size = 2;
                                  color = "ffffffff";
                                };
                              };
                            };
                            urgent.string = {
                              text = if n == "10" then "0" else n;
                              margin = 5;
                              deco = {
                                background = {
                                  color = "ff0000ff";
                                };
                              };
                            };
                            empty.string = {
                              text = if n == "10" then "0" else n;
                              margin = 5;
                              foreground = "666666ff";
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
                            { string = { text = ""; foreground = "ff0000ff"; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; font = awesome; }; }
                            { string = { text = ""; foreground = "00ff00ff"; font = awesome; }; }
                          ];
                        };
                      }
                      {
                        string = { text = " {capacity}%  {estimate}"; };
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
                          { string = { text = " {capacity}%  {estimate}"; }; }
                        ];
                        "state == full" = [
                          { string = { text = ""; foreground = "00ff00ff"; font = awesome; }; }
                          { string = { text = " {capacity}%  full"; }; }
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
