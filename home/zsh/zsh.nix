{ pkgs, lib, ... }:

{
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.cargo/bin"
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
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
    '';
  };
}
