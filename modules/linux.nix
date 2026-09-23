{ pkgs, ... }:

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

  # Autologin with greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd niri-session";
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

  # Docker setup
  virtualisation.docker.enable = true;

  users.users.kfish.extraGroups = [
    "networkmanager"
    "docker"
    "wireshark"
  ];
}
