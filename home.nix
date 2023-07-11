{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "kfish";
    homeDirectory = "/home/kfish";

    stateVersion = "22.11";

    packages = with pkgs; [
      # Utilities
      android-tools
      android-studio
      avahi
      dconf
      dig
      expect
      google-chrome
      gnome.nautilus
      gnumake
      git
      gh
      inetutils
      neofetch
      nixos-option
      pandoc
      tcptraceroute
      xidel
      wget
      zsh
      
      # Coq
      coq
      
      # Dart
      flutter

      # Haskell
      stack
      haskell-language-server

      # Java/Scala
      jdk11
      sbt

      # Lean
      elan

      # Node
      nodejs
      nodePackages.npm

      # Python
      (let
        pythonDatasciPackages = python-packages: with python-packages; [
          pip
          ipykernel
          pandas
          matplotlib
          seaborn
          requests
          beautifulsoup4
          kaggle
          selenium
          scikit-learn
          statsmodels
          svglib
          reportlab
          colorama
          notebook
        ];
        pythonWithPackages = python310.withPackages pythonDatasciPackages;
      in pythonWithPackages)
      

      # LaTeX
      texlive.combined.scheme-full
    ];
  };

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
      lfs.enable = true;
      userName = "Kevin Fisher";
      userEmail = "kfish610@gmail.com";
      extraConfig = {
        pull.ff = "only";
        core.autocrlf = "false";
        init.defaultBranch = "main";
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
      syntaxHighlighting.enable = true;
      profileExtra = ''
      npm set prefix /home/kfish/.npm-global
      '';
      localVariables = {
        PROMPT = "%B%(0?.%F{green}.%F{red}%? )> %f%b";
        RPROMPT = "%B%F{blue}%5~%f%b";
        PATH = "$PATH:/home/kfish/.npm-global/bin:/home/kfish/.cargo/bin:/bin";
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
