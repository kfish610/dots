{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs;
    [
      brightnessctl
      discord
      gparted
      # musescore
      openconnect
      remmina
      slack
      spotify
      sway-contrib.grimshot
      vscode
      zoom-us

      godot_4
      gimp

      rnote

      obsidian

      # Fonts
      dejavu_fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.sauce-code-pro
      source-code-pro
      material-design-icons
      font-awesome
    ]
    ++
      # nix store add --hash-algo sha256 --mode flat ~/Downloads/Wonderdraft-1.1.8.2b-Linux64.deb
      (
        let
          wonderdraftDebPath = "/nix/store/whg8cp587xr93lmdv21qj999y34bs0in-Wonderdraft-1.1.8.2b-Linux64.deb";
        in
        if builtins.pathExists wonderdraftDebPath then
          [ wonderdraft ]
        else
          builtins.trace "Warning: Wonderdraft .deb not found, skipping package." [ ]
      );
}
