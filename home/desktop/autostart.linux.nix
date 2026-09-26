{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;

  # Remembers which window an entry opened, so lookalikes (e.g. Chrome profiles) can be told apart
  autostart-window = pkgs.writeShellApplication {
    name = "autostart-window";

    runtimeInputs = [
      config.wayland.windowManager.niri.package
      pkgs.jq
    ];

    text = ''
      dir=$XDG_RUNTIME_DIR/autostart
      mkdir -p "$dir"

      case $1 in
        # Before launching: note the windows that are already open
        snapshot)
          rm -f "$dir/$2.window"
          niri msg --json windows | jq -c 'map(.id)' >"$dir/$2.before"
          ;;

        # After launching: wait for a new window matching the jq condition in file $3.
        # Something already running may take over the launch and open nothing, so give
        # up once the launched process has been gone a while, or after five minutes.
        wait)
          new="first(.[] | select(.id | IN($(<"$dir/$2.before")[]) | not) | select($(<"$3")) | .id)"
          gone=0

          for _ in $(seq 300); do
            id=$(niri msg --json windows | jq -r "$new")

            if [[ $id ]]; then
              echo "$id" >"$dir/$2.window"
              exit
            fi

            if ! kill -0 "''${MAINPID-}" 2>/dev/null && ((++gone >= 10)); then break; fi
            sleep 1
          done

          echo "No new window for $2" >&2
          ;;

        # The recorded window, if it is still open
        get)
          id=$(cat "$dir/$2.window" 2>/dev/null) || exit 1
          niri msg --json windows | jq -e "any(.id == $id)" >/dev/null || exit 1
          echo "$id"
          ;;
      esac
    '';
  };
in
{
  options.autostart = mkOption {
    default = { };
    description = "Programs to bring up with the graphical session.";

    type = types.attrsOf (
      types.submodule (
        { name, ... }:
        {
          options = {
            description = mkOption {
              type = types.str;
              default = name;
              description = "What systemctl and the journal call it.";
            };

            command = mkOption {
              type = types.listOf types.str;
              description = "Argv to run, quoted for you.";
            };

            after = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Other autostart entries that have to come up first.";
            };

            restart = mkOption {
              type = types.bool;
              default = false;
              description = "Bring it back up if it dies.";
            };

            window = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = ''.app_id == "discord" and .title != "Discord Updater"'';
              description = ''
                jq condition on an entry of `niri msg --json windows` that picks out
                the window this opens. The entry then only counts as up once a new
                such window appears (or it gives up), `autostart-window get <name>`
                gives its id, and rebuilds leave the running app alone.
              '';
            };

            timeout = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = ''
                Seconds to wait before giving up. Setting this declares the entry
                a task that finishes rather than something that stays running, so
                whatever is ordered after it waits for it to exit.
              '';
            };
          };
        }
      )
    );
  };

  config.lib.autostart.window = autostart-window;

  # Everything systemd wants that isn't already its own default.
  config.systemd.user.services = lib.mapAttrs (name: entry: {
    Unit = {
      Description = entry.description;
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ] ++ map (dep: "${dep}.service") entry.after;
    }
    // lib.optionalAttrs (entry.window != null) {
      # Relaunching an app that's already open would just open a stray window
      X-SwitchMethod = "keep-old";
    };

    Service = {
      ExecStart = lib.escapeShellArgs entry.command;
    }
    // lib.optionalAttrs (entry.window != null) {
      ExecStartPre = "${lib.getExe autostart-window} snapshot ${name}";
      ExecStartPost = "${lib.getExe autostart-window} wait ${name} ${pkgs.writeText "${name}-window.jq" entry.window}";

      # The wait gives up on its own, where systemd timing out would take the app down too
      TimeoutStartSec = "infinity";
    }
    // lib.optionalAttrs (entry.timeout != null) {
      Type = "oneshot";
      TimeoutStartSec = entry.timeout;
    }
    // lib.optionalAttrs entry.restart {
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  }) config.autostart;
}
