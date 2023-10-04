{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Agda
    (agda.withPackages (p: with p; [
      standard-library
    ]))

    # Android
    android-tools
    android-studio

    # C/C++
    gnumake
    cmake

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

    # LaTeX
    texlive.combined.scheme-full

    # Lean
    elan

    # Nix
    nil
    nixpkgs-fmt

    # Node
    nodejs
    nodePackages.npm

    # Python
    (
      let
        pythonDatasciPackages = ps: with ps; [
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
  ];
}
