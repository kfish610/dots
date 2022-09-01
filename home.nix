{ config, pkgs, ... }:

{
  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "kfish";
    homeDirectory = "/home/kfish";

    stateVersion = "22.05";

    packages = with pkgs; [
      # Utilities
      avahi
      dconf
      dig
      google-chrome
      gnome.nautilus
      git
      gh
      neofetch
      nixos-option
      gnumake
      wget
      zsh
      
      # Coq
      coq

      # Java/Scala
      jdk11
      sbt

      # Node
      nodejs
      nodePackages.npm
      
      # Haskell
      stack
      haskell-language-server

      # LaTeX
      texlive.combined.scheme-full
    ];
  };

  services.vscode-server.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Kevin Fisher";
      userEmail = "kfish610@gmail.com";
      extraConfig = {
        pull.ff = "only";
        core.autocrlf = "false";
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      dirHashes = {
        win = "/mnt/c/Users/kfish";
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      profileExtra = ''
      npm set prefix /home/kfish/.npm-global
      '';
      localVariables = {
        PROMPT = "%B%(0?.%F{green}.%F{red}%? )> %f%b";
        RPROMPT = "%B%F{blue}%5~%f%b";
        PATH = "$PATH:/home/kfish/.npm-global/bin";
      };
      shellAliases = {
        "link-desktop-files" = "sudo ln -s /home/kfish/.nix-profile/share/applications/*.desktop /usr/share/applications/";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "sudo" "history" "dirhistory" "gh" "npm" ];
      };
    };
  };
}
