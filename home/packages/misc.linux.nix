{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    discord
    gimp
    godot_4
    gparted
    loupe
    networkmanagerapplet
    obsidian
    rnote
    slack
    spotify
    sway-contrib.grimshot
    termius
    vscode
    wl-clipboard

    # I'd like to get this working again, but I'll need to read through https://github.com/NixOS/nixpkgs/issues/9415 and https://github.com/NixOS/nixpkgs/issues/267663
    # zoom-us

    (wonderdraft.overrideAttrs (old: {
      # Put back together the split .deb (it was too large for GitHub)
      src = pkgs.stdenv.mkDerivation {
        name = "wonderdraft.deb";
        src = ../../secrets/wonderdraft;
        buildPhase = ''
          cat $src/* > $out
        '';
      };
    }))

    # Fonts
    dejavu_fonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.sauce-code-pro
    source-code-pro
    material-design-icons
    font-awesome
    noto-fonts
  ];
}
