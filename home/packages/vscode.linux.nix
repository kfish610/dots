{ config, pkgs, ... }:

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

        if [[ $authd == tunnel+icc ]]; then cmd=${icc-code}/bin/icc-code; else cmd=code; fi

        case "$uri" in
          *.code-workspace) if [[ -z $auth ]]; then ex="$cmd $dpath"; else ex="$cmd --file-uri $uri"; fi ;;
          *)                ex="$cmd --folder-uri $uri" ;;
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

  icc-askpass = pkgs.writeShellScript "icc-askpass" ''
    prompt="''${1:-Password:}"
    case $prompt in *"asscode or option"*) printf '1\n'; exit 0 ;; esac
    prompt="''${prompt##*$'\n'}"
    case $prompt in "("*") "*) prompt="''${prompt#*") "}" ;; esac
    exec ${config.programs.fuzzel.package}/bin/fuzzel \
      --dmenu --password --width=50 --prompt-only="$prompt"
  '';

  icc-code = pkgs.writeShellApplication {
    name = "icc-code";
    runtimeInputs = [ pkgs.openssh ];
    text = ''
      export SSH_ASKPASS=${icc-askpass}

      ssh icc ./vscode.sh cpu

      code "$@"
    '';
  };
in
{
  home.packages = [
    pkgs.vscode
    icc-code
    vscode-workspaces
  ];

  programs.fuzzel.enable = true;

  # workspaceStorage changes as you use VS Code, so refresh on a timer.
  systemd.user.services.vscode-workspaces = {
    Unit.Description = "Refresh VS Code workspace launcher actions";
    Service = {
      Type = "oneshot";
      ExecStart = "${vscode-workspaces}/bin/vscode-workspaces";
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
