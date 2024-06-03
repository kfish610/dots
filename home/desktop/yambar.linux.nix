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
          spacing = 5;
          margin = 7;

          background = "00000066";

          right = [
            {
              clock = {
                time-format = "%H:%M %Z";
                content = [
                  { string = { text = ""; font = awesome; }; }
                  { string = { text = "{date}"; right-margin = 5; }; }
                  { string = { text = ""; font = awesome; }; }
                  { string = { text = "{time}"; }; }
                ];
              };
            }
          ];
        };
    };
  };
}
