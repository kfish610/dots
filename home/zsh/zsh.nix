{ ... }:

{
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      unsetopt EXTENDED_GLOB
      npm set prefix ~/.npm-global
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        source ~/.p10k.zsh
      else
        exec bash
      fi
    '';
    sessionVariables = {
      PATH = "$PATH:~/.npm-global/bin:~/.cargo/bin";
    };
    antidote = {
      enable = true;
      plugins = [
        "romkatv/powerlevel10k"
      ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "history"
        "dirhistory"
        "gh"
        "npm"
      ];
    };
  };
}
