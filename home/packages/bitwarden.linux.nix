{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Desktop (polkit/fingerprint) unlock is in bw, but gated by the server flag
  # biometrics-sdk-ipc, which is rolled out per account and still off for mine.
  # Drop the patch once this prints true (after `bw sync`):
  #   jq '[.. | .featureStates? // empty | .["biometrics-sdk-ipc"]] | unique' ~/.config/Bitwarden\ CLI/data.json
  bitwarden-cli = pkgs.bitwarden-cli.overrideAttrs (old: {
    postPatch = old.postPatch + ''
      substituteInPlace \
        apps/cli/src/key-management/cli-biometrics-service.ts \
        apps/cli/src/service-container/service-container.ts \
        --replace-fail "getFeatureFlag(FeatureFlag.BiometricsSDKIPC)" \
          "getFeatureFlag(FeatureFlag.BiometricsSDKIPC).then(() => true)"
    '';
    # bw only looks for the desktop's proxy in FHS paths like /opt/Bitwarden
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/bw --set-default BITWARDEN_DESKTOP_PROXY_PATH \
        ${pkgs.bitwarden-desktop}/libexec/desktop_proxy
    '';
  });

  # Automatically load SSH passwords from Bitwarden for the hosts without key-based auth
  # By item ID, since names like "illinois.edu" match several items
  passwords = {
    "cc-login.campuscluster.illinois.edu" = "65d2cb90-d1fa-4a08-b8d6-b2af00ed397f"; # illinois.edu (NetID)
    "ilab.cs.rutgers.edu" = "e8eff8d1-b7c2-4ba9-9166-b4c7012b643a"; # rutgers.edu
    "first" = "e8eff8d1-b7c2-4ba9-9166-b4c7012b643a"; # rutgers.edu
  };
in
{
  home.packages = [ bitwarden-cli ];

  programs.fuzzel.enable = true;

  autostart.bitwarden = {
    command = [ (lib.getExe pkgs.bitwarden-desktop) ];
    after = [ "wait-for-tray" ];
  };

  # Set as SSH_ASKPASS by programs.ssh.askPassword in modules/linux.nix
  lib.bitwarden.askpass = pkgs.writeShellApplication {
    name = "bw-askpass";
    runtimeInputs = [
      bitwarden-cli
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
        (umask 077; timeout 90 bw unlock --raw </dev/null >"$session") || true
        get && { refresh; exit; }
      fi

      prompt=''${prompt##*$'\n'}
      case $prompt in "("*") "*) prompt=''${prompt#*") "} ;; esac
      exec fuzzel --dmenu --password --width=50 --prompt-only="$prompt"
    '';
  };
}
