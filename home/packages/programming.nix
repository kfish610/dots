{ pkgs, ... }:

let
  buildToolsVersion = "35.0.0";
  ndkVersion = "28.1.13356709";
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [
      "google_apis"
      "google_apis_playstore"
    ];
    buildToolsVersions = [ buildToolsVersion ];
    cmdLineToolsVersion = "8.0";
    ndkVersion = ndkVersion;
    platformVersions = [ "35" ];
    abiVersions = [
      "x86_64"
      "armeabi-v7a"
      "arm64-v8a"
    ];
    useGoogleAPIs = true;
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };

  ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
in
{
  programs.zsh.sessionVariables = {
    ANDROID_HOME = ANDROID_HOME;
    ANDROID_SDK_ROOT = ANDROID_HOME;
    ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk/${ndkVersion}";
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2";
    QT_QPA_PLATFORM = "wayland;xcb";
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
