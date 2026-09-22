{
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.monitors = mkOption {
    default = { };
    description = "Displays attached to this machine, described once.";

    type = types.attrsOf (
      types.submodule {
        options = {
          make = mkOption {
            type = types.str;
            description = "EDID manufacturer, spelled as the compositor reports it.";
          };

          model = mkOption {
            type = types.str;
            description = "EDID model, spelled as the compositor reports it.";
          };

          serial = mkOption {
            type = types.str;
            description = "EDID serial, which is what tells two identical panels apart.";
          };
        };
      }
    );
  };

  config.lib.monitors = {
    niriName = m: "${m.make} ${m.model} ${m.serial}";
    dmsName = m: m.model;
  };
}
