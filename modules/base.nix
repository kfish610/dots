{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings.trusted-users = [
      "root"
      "kfish"
    ];
  };

  # Localization
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Required for sway. Also generally useful
  security.polkit.enable = true;

  # Use Pipewire for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Misc. services
  services.tlp.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;

  # Needed for lots of compatibility things!
  # Namely conda/mamba/poetry
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      stdenv.cc.cc.lib
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
    ];
  };

  # Set up user with zsh
  programs.zsh.enable = true;
  users.users.kfish = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/kfish";
    extraGroups = [
      "wheel"
      "wireshark"
    ];
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
