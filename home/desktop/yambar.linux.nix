{ pkgs, config, ... }:

{
  programs.yambar = {
    enable = true;
    settings =
      {
        bar =
          let
            awesome = "Font Awesome 6 Free:style=solid:pixelsize=14";
          in
          {
            location = "top";

            height = 32;
            spacing = 12;
            margin = 24;

            font = "${config.constants.sway.disp_font}:pixelsize=16";
            background = "00000066";

            left = [
              {
                label.content = [
                  {
                    string = {
                      on-click = config.constants.sway.exit_cmd;
                      text = "";
                      font = awesome;
                      foreground = "dd5555ff";
                      right-margin = 16;
                    };
                  }

                  {
                    string = {
                      on-click = config.constants.sway.restart_cmd;
                      text = "";
                      font = awesome;
                      foreground = "dd5555ff";
                    };
                  }
                ];
              }

              {
                i3 = rec {
                  right-spacing = 6;
                  persistent = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
                  content =
                    let
                      workspace = n: {
                        name = n;
                        value = let s = { text = if n == "10" then "0" else n; margin = 8; }; in {
                          map = {
                            default.string = s;
                            conditions = {
                              empty.string = s // {
                                foreground = "ffffff66";
                              };
                              focused.string = s // {
                                deco.underline = {
                                  size = 2;
                                  color = "ffffffff";
                                };
                              };
                              urgent.string = s // {
                                deco.background.color = "dd5555ff";
                              };
                            };
                          };
                        };
                      };
                    in
                    builtins.listToAttrs (map workspace persistent);
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
                network = {
                  poll-interval = 2500;
                  content.map = {
                    default.empty = { };
                    conditions."name == wlan0".map = {
                      default.string = {
                        text = "";
                        font = awesome;
                        foreground = "ffffff66";
                      };
                      conditions = {
                        "state == down".string = { text = ""; font = awesome; foreground = "ff0000ff"; };
                        "state == up" = [
                          { string = { text = ""; font = awesome; }; }
                          { string.text = " {ssid} ↑{ul-speed:mb} ↓{dl-speed:mb} Mb/s"; }
                        ];
                      };
                    };
                  };
                };
              }

              {
                cpu = {
                  poll-interval = 2500;
                  content.map.conditions."id == -1" = [
                    { string = { text = ""; font = awesome; }; }
                    { string.text = " {cpu:02}%"; }
                  ];
                };
              }

              {
                mem = {
                  poll-interval = 2500;
                  content = [
                    { string = { text = ""; font = awesome; }; }
                    { string.text = " {percent_used:02}%"; }
                  ];
                };
              }

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
                          string = { text = " {capacity:02}% {estimate}"; };
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
                            { string = { text = " {capacity:02}% {estimate}"; }; }
                          ];
                          "state == full" = [
                            { string = { text = ""; foreground = "00ff00ff"; font = awesome; }; }
                            { string = { text = " {capacity:02}% full"; }; }
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
