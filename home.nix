{ pkgs, ... }:

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
      cmake
      dconf
      dig
      expect
      gcc
      gcc-arm-embedded-6
      google-chrome
      gnome.nautilus
      gnumake
      git
      gh
      inetutils
      imagemagick
      neofetch
      nil
      nix-index
      nixos-option
      nixpkgs-fmt
      pandoc
      sshpass
      tcptraceroute
      ubootTools
      unzip
      xidel
      wget
      zsh

      # Agda
      (agda.withPackages (p: with p; [
        standard-library
      ]))

      # C
      gcc

      # Coq
      coq

      # Dart
      flutter

      # Fonts
      (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })
      source-code-pro
      dejavu_fonts

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
      (
        let
          pythonDatasciPackages = python-packages: with python-packages; [
            pybluez
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
        in
        pythonWithPackages
      )


      # LaTeX
      texlive.combined.scheme-full
    ];

    file = {
      ".emacs.d" = {
        source = builtins.fetchGit {
          url = "https://github.com/syl20bnr/spacemacs";
          ref = "develop";
        };
        recursive = true;
      };

      ".spacemacs".source = ./spacemacs.el;

      ".p10k.zsh".source = ./.p10k.zsh;
    };
  };

  fonts.fontconfig.enable = true;

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

    emacs.enable = true;

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
      initExtra = ''
        npm set prefix /home/kfish/.npm-global
        source /home/kfish/.p10k.zsh
      '';
      localVariables = {
        PATH = "$PATH:/home/kfish/.npm-global/bin:/home/kfish/.cargo/bin:/bin";
      };
      shellAliases = {
        "link-desktop-files" = "sudo ln -s /home/kfish/.nix-profile/share/applications/*.desktop /usr/share/applications/";
      };
      antidote = {
        enable = true;
        plugins = [
          "romkatv/zsh-bench kind:path"
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
  };
}
