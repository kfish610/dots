{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Automatically load SSH passwords from Bitwarden for the hosts without key-based auth
  passwords = {
    "cc-login.campuscluster.illinois.edu" = "illinois.edu";
    "ilab.cs.rutgers.edu" = "rutgers.edu";
    "first" = "rutgers.edu";
  };
  askpass = pkgs.writeShellApplication {
    name = "bw-askpass";
    runtimeInputs = [
      pkgs.bitwarden-cli
      pkgs.coreutils
      pkgs.util-linux
      config.programs.fuzzel.package
    ];
    text = ''
      prompt=$1
      case $prompt in *"Passcode or option"*) echo 1; exit ;; esac # Duo push

      # "(user@host) Password:" or "user@host's password:"
      re="@([^ )']+)"
      entry=
      [[ $prompt =~ $re ]] && case ''${BASH_REMATCH[1]} in
        ${lib.concatStringsSep "\n  " (
          lib.mapAttrsToList (
            host: entry: "${lib.escapeShellArg host}) entry=${lib.escapeShellArg entry} ;;"
          ) passwords
        )}
      esac

      if [[ -n $entry ]]; then
        # Kept until reboot, so the desktop app is asked once per boot
        session=$XDG_RUNTIME_DIR/bw-session
        get() {
          BW_SESSION=$(cat "$session" 2>/dev/null) BW_NOINTERACTION=true \
            bw get password "$entry" 2>/dev/null
        }
        # Answer from the local copy, then refresh it in the background so a
        # changed password is picked up by ssh's retry without making it wait
        refresh() {
          BW_SESSION=$(cat "$session") setsid -f \
            flock -n "$session.lock" bw sync </dev/null &>/dev/null
        }
        get && { refresh; exit; }
        # Unlocks through the desktop app (polkit/fingerprint). The timeout
        # guards against bw hanging after printing the session (bitwarden/clients#24446).
        (umask 077; timeout 30 bw unlock --raw </dev/null >"$session") || true
        get && { refresh; exit; }
      fi

      prompt=''${prompt##*$'\n'}
      case $prompt in "("*") "*) prompt=''${prompt#*") "} ;; esac
      exec fuzzel --dmenu --password --width=50 --prompt-only="$prompt"
    '';
  };
in
{
  home.packages = [ pkgs.bitwarden-cli ];

  programs.fuzzel.enable = true;

  autostart.bitwarden = {
    command = [ (lib.getExe pkgs.bitwarden-desktop) ];
    after = [ "wait-for-tray" ];
  };

  systemd.user.sessionVariables = {
    SSH_ASKPASS = lib.getExe askpass;
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
