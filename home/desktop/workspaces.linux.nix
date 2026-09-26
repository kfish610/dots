{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;

  cfg = config.workspaces;

  windows = lib.concatMap (ws: lib.concatLists ws.columns) cfg;
  columns = lib.concatMap (ws: map (column: [ ws.name ] ++ column) ws.columns) cfg;

  arrange-workspaces = pkgs.writeShellApplication {
    name = "arrange-workspaces";

    runtimeInputs = [
      config.wayland.windowManager.niri.package
      config.lib.autostart.window
      pkgs.jq
      pkgs.procps
    ];

    text = ''
      # Whether two windows already share a column
      together() {
        niri msg --json windows | jq -e "
          map(select(.id == $1 or .id == $2) | [.workspace_id, .layout.pos_in_scrolling_layout[0]])
          | unique | length == 1
        " >/dev/null
      }

      # Stack windows into a column at the front of workspace $1, leaving out any that
      # never opened or have since closed
      column() {
        local ws=$1 head="" id name
        shift

        for name; do
          id=$(autostart-window get "$name") || continue
          niri msg action move-window-to-workspace --window-id "$id" --focus false "$ws"
          niri msg action focus-window --id "$id"

          if [[ -z $head ]]; then
            head=$id
            niri msg action move-column-to-first
          elif ! together "$head" "$id"; then
            niri msg action move-column-to-index 2
            niri msg action focus-window --id "$head"
            niri msg action consume-window-into-column
          fi
        done
      }

      while pgrep swaylock >/dev/null; do sleep 1; done

      # Back to front, since each column goes in at the front and the first workspace
      # should end up in view
      ${lib.concatMapStrings (column: ''
        column ${lib.escapeShellArgs column}
      '') (lib.reverseList columns)}
    '';
  };
in
{
  options.workspaces = mkOption {
    default = [ ];
    description = "Named workspaces, in order, and the autostarted windows to arrange on them.";

    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Workspace name, which niri places before any unnamed ones.";
          };

          output = mkOption {
            type = types.str;
            description = "Output the workspace lives on, as niri names it.";
          };

          columns = mkOption {
            type = types.listOf (types.nonEmptyListOf types.str);
            default = [ ];
            description = ''
              Columns from left to right, each a stack of windows from top to bottom,
              named by the autostart entries (with a `window` set) that open them.
            '';
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg != [ ]) {
    assertions = map (name: {
      assertion = config.autostart.${name}.window or null != null;
      message = "workspaces: `${name}` needs to be an autostart entry with `window` set.";
    }) windows;

    wayland.windowManager.niri.settings._children = map (ws: {
      workspace = {
        _args = [ ws.name ];
        open-on-output = ws.output;
      };
    }) cfg;

    home.packages = [ arrange-workspaces ];

    autostart.arrange-workspaces = {
      description = "Arrange autostarted windows onto their workspaces";
      command = [ (lib.getExe arrange-workspaces) ];
      after = lib.unique windows;
    };
  };
}
