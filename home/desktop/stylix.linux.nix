{ pkgs, ... }:

{
  stylix = {
    enable = true;

    polarity = "dark";
    base16Scheme = {
      base00 = "#0e1920";
      base01 = "#17232b";
      base02 = "#384953";
      base03 = "#5e7887";
      base04 = "#838f96";
      base05 = "#c5cdd3";
      base06 = "#c5cdd3";
      base07 = "#c5cdd3";
      base08 = "#eab464";
      base09 = "#7068b1";
      base0A = "#5998c0";
      base0B = "#72c09f";
      base0C = "#3f8d6c";
      base0D = "#3f848d";
      base0E = "#c88da2";
      base0F = "#b16a4e";
    };

    image = ./CelesteCh8.png;

    fonts.monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
    };

    opacity.terminal = 0.8;

    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "rose-pine-cursor";
      size = 24;
    };
  };
}
