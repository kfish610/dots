{ ... }:

{
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      PATH = "$PATH:~/.npm-global/bin:~/.cargo/bin";
      WLR_DRM_NO_MODIFIERS = 1;
    };
    antidote = {
      enable = true;
      plugins = [
        "romkatv/powerlevel10k"
      ];
    };
    initExtraFirst = ''
      # Load powerline10k only if the terminal supports it
      # Otherwise just use bash
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        source ~/.p10k.zsh
      else
        exec bash
      fi
    '';
    initExtra = ''
      # Turn off extended glob, it is mostly useless and clashes with flakes
      unsetopt EXTENDED_GLOB
    '';
  };
}
