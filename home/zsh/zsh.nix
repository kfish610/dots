{ pkgs, lib, ... }:

{
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      PATH = "$PATH:~/.npm-global/bin:~/.cargo/bin";
      WLR_DRM_NO_MODIFIERS = 1;
      CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
      MAMBA_ROOT_PREFIX = "/home/kfish/micromamba";
    };
    antidote = {
      enable = true;
      plugins = [
        "romkatv/powerlevel10k"
      ];
    };
    initContent = lib.mkBefore ''
      # Load powerline10k only if the terminal supports it
      # Otherwise just use bash
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        source ~/.p10k.zsh
      else
        exec bash
      fi

      # Turn off extended glob, it is mostly useless and clashes with flakes
      unsetopt EXTENDED_GLOB

      # Set NPM global in the user directory so it doesn't clash with Nix
      npm set prefix ~/.npm-global
    '';
  };
}
