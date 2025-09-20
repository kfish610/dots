{ pkgs, ... }:

{
  # Use networkmanager for networking
  networking.networkmanager.enable = true;
  users.groups.networkmanager.members = [ "kfish" ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Autologin with greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd Hyprland";
      };
      initial_session = {
        user = "kfish";
        command = "Hyprland";
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

  # Misc. services
  services.tlp.enable = true;
  services.printing.enable = true;

  # Sometimes needed for permission elevation
  security.polkit.enable = true;

  # Programs that have to be enabled in the system config to work properly
  programs = {
    hyprland.enable = true;

    wireshark = {
      enable = true;
      package = pkgs.wireshark; # Default module has an incorrect package name
    };
  };

  # Setup SwayOSD
  environment.systemPackages = [ pkgs.swayosd ];
  services.udev.packages = [ pkgs.swayosd ];
  # Start the libinput backend for SwayOSD
  systemd.services.swayosd-libinput-backend = {
    description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
    documentation = [ "https://github.com/ErikReider/SwayOSD" ];
    wantedBy = [ "graphical.target" ];
    partOf = [ "graphical.target" ];
    after = [ "graphical.target" ];

    serviceConfig = {
      Type = "dbus";
      BusName = "org.erikreider.swayosd";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "on-failure";
    };
  };

  # Docker setup
  virtualisation.docker.enable = true;
  users.groups.docker.members = [ "kfish" ];
}
