{ pkgs, ... }:

{
  home.file.".p10k.zsh".source = ./.p10k.zsh;
  home.packages = with pkgs; [ pywal ];

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtraFirst = ''
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        source ~/.p10k.zsh
      else
        exec bash
      fi
    '';
    initExtra = ''
      unsetopt EXTENDED_GLOB
      npm set prefix ~/.npm-global
      (cat ~/.cache/wal/sequences &)
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
