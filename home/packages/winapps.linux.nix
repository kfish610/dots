{
  pkgs,
  config,
  winapps,
  ...
}:

# Runs Windows apps (PowerPoint) from a Windows VM in Docker as regular windows over RDP.
# First-time setup is manual: `docker compose -f ~/.config/winapps/compose.yaml up -d`,
# watch the install at http://127.0.0.1:8006, install Office, then `winapps-setup --user`.
let
  # Only used for RDP to the VM, which is bound to localhost
  user = "kfish";
  password = "winapps";
in
{
  home.packages = [ winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps ];

  xdg.configFile."winapps/winapps.conf".text = ''
    RDP_USER="${user}"
    RDP_PASS="${password}"
    RDP_IP="127.0.0.1"
    RDP_PORT="3389"
    WAFLAVOR="docker"
    RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"
    DEBUG="true"

    # Pause the VM when no Windows apps have been open for a while
    AUTOPAUSE="on"
    AUTOPAUSE_TIME="300"
  '';

  # Based on https://github.com/winapps-org/winapps/blob/main/compose.yaml
  xdg.configFile."winapps/compose.yaml".text = builtins.toJSON {
    name = "winapps";
    volumes.data = { };
    services.windows = {
      image = "ghcr.io/dockur/windows:latest";
      container_name = "WinApps";
      environment = {
        VERSION = "11";
        RAM_SIZE = "8G";
        CPU_CORES = "4";
        DISK_SIZE = "64G";
        USERNAME = user;
        PASSWORD = password;
        HOME = config.home.homeDirectory;
      };
      ports = [
        # Web VNC, used to watch the Windows install
        "127.0.0.1:8006:8006"
        "127.0.0.1:3389:3389/tcp"
        "127.0.0.1:3389:3389/udp"
      ];
      cap_add = [
        "NET_ADMIN"
        "NET_RAW"
      ];
      stop_grace_period = "120s";
      restart = "on-failure";
      volumes = [
        # The Windows C: drive
        "data:/storage"
        # Shows up as \\host.lan\Data in Windows
        "${config.home.homeDirectory}:/shared"
        # Runs once after the Windows install to enable RDP RemoteApp
        "${winapps}/oem:/oem"
      ];
      devices = [
        "/dev/kvm"
        "/dev/net/tun"
      ];
    };
  };
}
