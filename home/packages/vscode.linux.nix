{ lib, pkgs, ... }:

let
  vscode-workspaces = pkgs.writeShellApplication {
    name = "vscode-workspaces";
    runtimeInputs = [
      pkgs.jq
      pkgs.desktop-file-utils
    ];
    text = ''
      WS="$HOME/.config/Code/User/workspaceStorage"
      APPS="''${XDG_DATA_HOME:-$HOME/.local/share}/applications"
      SRC=${pkgs.vscode}/share/applications/code.desktop
      MAX=15

      decode() { printf '%b' "''${1//%/\\x}"; }

      list() {
        find "$WS" -mindepth 1 -maxdepth 1 -type d -printf '%T@\t%p\n' 2>/dev/null |
          sort -rn | cut -f2 |
          while read -r d; do
            [[ -f $d/workspace.json ]] && jq -r '.folder // .workspace // empty' "$d/workspace.json"
          done | awk 'NF && !seen[$0]++'
      }

      ids=""
      bodies=""
      n=0

      while read -r uri; do
        ((n < MAX)) || break
        case "$uri" in
          file://*)          auth=""; path=''${uri#file://} ;;
          vscode-remote://*) u=''${uri#vscode-remote://}; auth=''${u%%/*}; path=/''${u#*/} ;;
          *) continue ;;
        esac

        dpath=$(decode "$path")
        case "$dpath" in /tmp/*) continue ;; esac                  # Live Share scratch
        if [[ -z $auth && ! -e $dpath ]]; then continue; fi  # deleted locally

        authd=$(decode "$auth"); kind=''${authd%%+*}; host=''${authd#*+}
        label=$(basename "$dpath")
        case "$label" in *.code-workspace) label="''${label%.code-workspace} (Workspace)" ;; esac
        case "$kind" in
          "")         ;;
          ssh-remote) label="$label [SSH: $host]" ;;
          *)          label="$label [''${kind^}: $host]" ;;
        esac

        case "$uri" in
          *.code-workspace) if [[ -z $auth ]]; then ex="code $dpath"; else ex="code --file-uri $uri"; fi ;;
          *)                ex="code --folder-uri $uri" ;;
        esac
        ex=''${ex//%/%%}  # a % left in Exec= is a field code

        ((n++)) || true
        ids+="ws$n;"
        bodies+=$(printf '[Desktop Action ws%s]\nName=%s\nExec=%s\nIcon=vscode' "$n" "$label" "$ex")$'\n\n'
      done < <(list)

      mkdir -p "$APPS"
      # Append our ids to whatever Actions= the packaged entry already has.
      { sed -E "s|^Actions=(.*)$|Actions=\\1;$ids|" "$SRC"; printf '\n%s' "$bodies"; } \
        > "$APPS/code.desktop"

      update-desktop-database "$APPS" 2>/dev/null || true
    '';
  };

  # Run an `ssh` command to launch/wake a tunnel that needs to be started remotely.
  tunnels = {
    icc = [
      "icc"
      "./vscode.sh"
      "cpu"
    ];
  };
  tunnel-wake = pkgs.linkFarm "tunnel-wake" {
    "package.json" = pkgs.writeText "package.json" (
      builtins.toJSON {
        name = "tunnel-wake";
        publisher = "local";
        version = "0.0.1";
        engines.vscode = "^1.80.0";
        main = "./extension.js";
        activationEvents = [ "onResolveRemoteAuthority:tunnel" ];
        extensionKind = [ "ui" ];
      }
    );
    "extension.js" = pkgs.writeText "extension.js" ''
      const vscode = require("vscode");
      const { execFile } = require("child_process");

      const tunnels = ${builtins.toJSON tunnels};

      exports.activate = () => {
        const { workspaceFolders = [], workspaceFile } = vscode.workspace;
        const uris = [...workspaceFolders.map((f) => f.uri), workspaceFile];
        const name = uris.find((u) => u?.authority.startsWith("tunnel+"))?.authority.slice(7);
        if (!Object.hasOwn(tunnels, name)) return;

        execFile("${lib.getExe pkgs.openssh}", tunnels[name], (err, _out, stderr) => {
          if (err) vscode.window.showErrorMessage(name + " tunnel: " + (stderr || err.message));
        });
      };
    '';
  };
in
{
  home.packages = [
    pkgs.vscode
    vscode-workspaces
  ];

  home.file.".vscode/extensions/local.tunnel-wake-0.0.1".source = tunnel-wake;

  # workspaceStorage changes as you use VS Code, so refresh on a timer.
  systemd.user.services.vscode-workspaces = {
    Unit.Description = "Refresh VS Code workspace launcher actions";
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe vscode-workspaces;
    };
  };
  systemd.user.timers.vscode-workspaces = {
    Unit.Description = "Refresh VS Code workspace launcher actions";
    Timer = {
      OnStartupSec = "1m";
      OnUnitActiveSec = "5m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
