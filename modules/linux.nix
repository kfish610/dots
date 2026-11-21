{ lib, pkgs, ... }:

{
  imports = [
    ./stylix
    ./base.nix
  ];

  # Use chrony for time synchronization (instead of systemd-timesyncd)
  services.chrony.enable = true;

  # Use networkmanager for networking
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openconnect ];
    dns = "systemd-resolved";
  };

  # Use systemd-resolved for DNS resolution
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = true;
      DNSOverTLS = true;
      Domains = [ "~." ];
    };
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  programs.nix-ld.libraries = with pkgs; [ vulkan-loader ];

  # Autologin with greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe' pkgs.greetd "agreety"} --cmd niri-session";
      };
      initial_session = {
        user = "kfish";
        command = "niri-session";
      };
    };
  };

  # Use Pipewire for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  zramSwap.enable = true;

  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
  };

  # Misc. services
  services.printing.enable = true;

  # Programs that have to be enabled in the system config to work properly
  programs = {
    # Session-level plumbing: niri-session for greetd, xdg portals, polkit,
    # dconf, pam.services.swaylock, gnome-keyring, XDG autostart.
    # Actual niri configuration lives in home/desktop/niri.linux.nix.
    niri.enable = true;

    wireshark = {
      enable = true;
      package = pkgs.wireshark; # Default is wireshark-cli, we want the GUI
    };
  };

  # System-wide since polkit only loads Bitwarden's unlock policy from here
  environment.systemPackages = [ pkgs.bitwarden-desktop ];

  # Synchronized unlock (browser follows the desktop app) needs 2026.11
  nixpkgs.overlays = [
    (final: prev: {
      bitwarden-desktop =
        lib.warnIfNot (lib.versionOlder prev.bitwarden-desktop.version "2026.11.0")
          "nixpkgs has bitwarden-desktop ${prev.bitwarden-desktop.version}; drop the override in modules/linux.nix"
          prev.bitwarden-desktop.overrideAttrs
          (
            finalAttrs: old: {
              version = "2026.11.0";
              src = old.src.override {
                tag = "desktop-v${finalAttrs.version}";
                hash = "sha256-l/YdVJveeQC0dNCCzeM5ns19QKyOcSohUgA2RNP/VMU=";
              };
              # buildNpmPackage and the package bake these from their own args
              npmDeps = final.fetchNpmDeps {
                inherit (finalAttrs) src patches postPatch;
                name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
                hash = "sha256-I+8QA5r2cDhmGg8YxNmVurhyVU8vCwU4qXTDg4VelRQ=";
                fetcherVersion = 2;
              };
              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit (finalAttrs)
                  pname
                  version
                  src
                  cargoRoot
                  patches
                  ;
                hash = "sha256-fUMCzkAUCiCdH0FdiyEQZIvcHJUGPv1YASwLOHEwN4E=";
              };
              # nixpkgs' zbus test skip, after upstream renamed password::password
              checkFlags = old.checkFlags ++ [ "--skip=password::os::tests" ];
            }
          );
    })
  ];

  # Docker setup
  virtualisation.docker.enable = true;

  # The WinApps Windows VM container needs these for folder sharing with the host
  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];

  users.users.kfish.extraGroups = [
    "networkmanager"
    "docker"
    "wireshark"
  ];
}
