{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
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

  # Everything systemd wants that isn't already its own default.
  config.systemd.user.services = lib.mapAttrs (_: entry: {
    Unit = {
      Description = entry.description;
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ] ++ map (dep: "${dep}.service") entry.after;
    };

    Service = {
      ExecStart = lib.escapeShellArgs entry.command;
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
