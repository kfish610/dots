{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.opam.enable = true;

  programs.npm = {
    enable = true;
    package = pkgs.nodejs_latest;
    # Set NPM global in the user directory so it doesn't clash with Nix
    settings.prefix = "\${HOME}/.npm-global";
  };

  home.packages = with pkgs; [
    # Agda
    (agda.withPackages (
      p: with p; [
        standard-library
        agda-categories
      ]
    ))

    # Android
    android-studio
    android-tools

    # C/C++
    gnumake
    cmake
    gcc

    # Clojure
    clojure
    leiningen
    babashka

    # Dafny
    dafny

    # Rocq
    rocq-core
    rocqPackages.vsrocq-language-server
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
    (texlive.withPackages (p: [ p.scheme-full ]))

    # Lean
    elan

    # Nix
    nixd
    nixfmt
    devenv

    # OCaml
    dune

    # Python
    python312
    uv

    # Qt
    qt6.qtdeclarative

    # SPIN
    spin

    # TypeScript
    typescript

    # Web
    insomnia
  ];
}
