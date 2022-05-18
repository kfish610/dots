{ config, pkgs, ... }:

{
  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "kfish";
    homeDirectory = "/home/kfish";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";

    packages = with pkgs; [
      git
      gh
      texlive.combined.scheme-full
      wget
      zsh
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Kevin Fisher";
      userEmail = "kfish610@gmail.com";
      extraConfig = {
        pull.ff = "only";
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      localVariables = {
        PROMPT = "%B%(0?.%F{green}.%F{red}%? )> %f%b";
        RPROMPT = "%B%F{blue}%~%f%b";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "sudo" "history" "dirhistory" ];
      };
    };
  };

  services.vscode-server.enable = true;
}
