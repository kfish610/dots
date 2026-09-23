{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Applications
    discord
    gimp
    godot_4
    gparted
    loupe
    obsidian
    rnote
    slack
    spotify
    termius
    zoom-us

    # Tools
    pciutils

    (wonderdraft.overrideAttrs (old: {
      # Put back together the split .deb (it was too large for GitHub)
      src = pkgs.runCommand "wonderdraft.deb" { } ''
        cat ${../../secrets/wonderdraft}/* > $out

        head -c 8 $out | grep -q '^!<arch>$' || {
          echo "secrets/ is still git-crypt locked; see the README" >&2
          exit 1
        }
      '';
    }))
  ];
}
