{ pkgs, ... }:

{
  programs.zsh.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  home.packages = with pkgs; [
    # Agda
    (agda.withPackages (
      p: with p; [
        standard-library
      ]
    ))

    # C/C++
    gnumake
    cmake
    gcc

    # Clojure
    clojure
    leiningen
    babashka

    # Rocq
    rocq-core
    coqPackages.vscoq-language-server
    coqPackages.coq-lsp

    # Exercism
    exercism

    # Haskell
    stack
    haskell-language-server

    # Java/Scala
    jdk
    sbt

    # LaTeX
    texlive.combined.scheme-full

    # Lean
    elan

    # Nix
    nixd
    nixfmt-rfc-style
    devenv

    # Node
    nodejs_latest

    # Python
    python312
    uv

    # Qt
    qt6.qtdeclarative
  ];
}
