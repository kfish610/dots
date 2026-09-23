{ pkgs, ... }:

{
  home.packages = with pkgs; [
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

    # Tools
    pciutils

    # I'd like to get this working again, but I'll need to read through https://github.com/NixOS/nixpkgs/issues/9415 and https://github.com/NixOS/nixpkgs/issues/267663
    # zoom-us

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
