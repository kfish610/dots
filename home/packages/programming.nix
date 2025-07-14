{ pkgs, ... }:

let
  buildToolsVersion = "35.0.0";
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeEmulator = true;
    includeNDK = true;
    buildToolsVersions = [ buildToolsVersion ];
    ndkVersion = "28.1.13356709";
    platformVersions = [ "35" ];
    abiVersions = [
      "x86_64"
      "armeabi-v7a"
      "arm64-v8a"
    ];
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "mips-android-sysimage-license"
    ];
  };

  ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2";
in
{
  programs.zsh.sessionVariables = {
    ANDROID_HOME = ANDROID_HOME;
    ANDROID_NDK_ROOT = ANDROID_NDK_ROOT;
    GRADLE_OPTS = GRADLE_OPTS;
  };

  home.packages =
    with pkgs;
    [
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

      # Coq
      coq
      # coqPackages.vscoq-language-server
      # coqPackages.coq-lsp

      # Exercism
      exercism

      # Flutter
      flutter
      androidComposition.androidsdk

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
      nil
      nixfmt-rfc-style
      devenv

      # Node
      nodejs_latest

      # Python
      python312
      micromamba

      # Qt
      qt6.qtdeclarative
    ]
    ++ (
      let
        rOverride = {
          packages = with pkgs.rPackages; [
            # For the editor
            languageserver
            # httpgd
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
