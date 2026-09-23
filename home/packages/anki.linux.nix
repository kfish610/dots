{ config, pkgs, ... }:

{
  # Stylix's Anki target uses base07 for subtle borders and highlights, which is bright on a dark palette
  stylix.targets.anki.colors.override.withHashtag.base07 =
    config.lib.stylix.colors.withHashtag.base00;

  programs.anki = {
    enable = true;
    theme = "followSystem";

    addons = with pkgs.ankiAddons; [
      review-heatmap
    ];
  };
}
