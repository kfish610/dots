{ pkgs, ... }:

{
  imports = [
    ./stylix
    ./base.nix
  ];

  time.hardwareClockInLocalTime = true;

  # Use networkmanager for networking
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openconnect ];
  };
  users.groups.networkmanager.members = [ "kfish" ];

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

  # Misc. services
  services.tlp.enable = true;
  services.printing.enable = true;

  # Sometimes needed for permission elevation
  security.polkit.enable = true;

  # Programs that have to be enabled in the system config to work properly
  programs = {

    niri.enable = true;

    wireshark = {
      enable = true;
      package = pkgs.wireshark; # Default module has an incorrect package name
    };
  };

  users.groups.adbusers.members = [ "kfish" ];

  # Docker setup
  virtualisation.docker.enable = true;
  users.groups.docker.members = [ "kfish" ];
}
