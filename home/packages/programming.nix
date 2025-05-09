{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      # Agda
      (agda.withPackages (
        p: with p; [
          standard-library
        ]
      ))

      # Android
      android-studio

      # C/C++
      gnumake
      cmake
      gcc

      # Clojure
      clojure
      leiningen
      babashka

      # Coq
      coq
      # coqPackages.vscoq-language-server
      # coqPackages.coq-lsp

      # Dart
      flutter

      # Exercism
      exercism

      # Haskell
      stack
      haskell-language-server

      # Java/Scala
      jdk11
      sbt

      # LaTeX
      texlive.combined.scheme-full

      # Lean
      elan

      # Nix
      nil
      nixfmt-rfc-style

      # Node
      nodejs_latest

      # Python
      python312
      micromamba
    ]
    ++ (
      let
        rOverride = {
          packages = with pkgs.rPackages; [
            # For the editor
            languageserver
            httpgd
            rmarkdown

            # Tidyverse
            tidyverse
            tidymodels
          ];
        };
      in
      [
        (rWrapper.override rOverride)
        (radianWrapper.override rOverride)
      ]
    );
}
