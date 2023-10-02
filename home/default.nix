{ lib, systemInfo, ... }:

let
  # Take the flat directory from readDir, and dig further into directories
  readDirRec = path:
    let
      recurseIfDir = name: type:
        if type == "directory" then readDirRec "${path}/${name}" else type;
    in
    lib.mapAttrs recurseIfDir (builtins.readDir path);

  # Take a file tree (as an attrset), and remove files with the wrong system
  filterBySystem = set:
    let
      isCorrectSystem = name: type:
        let
          components = (lib.splitString "." name);
          # Is not this file
          isNotDefault = (lib.head components) != "default";
          # Must be a nix file
          isNix = (lib.last components) == "nix";
          # Is either just a file name + nix ending or...
          isSimple = (builtins.length components) == 2;
          # all intermediate components are in systemInfo, giving empty list
          isAllowed = (lib.subtractLists systemInfo (lib.init (lib.tail components))) == [ ];
        in
        # Skip if is attrset
        (builtins.isAttrs type) || (isNotDefault && isNix && (isSimple || isAllowed));
    in
    lib.filterAttrsRecursive isCorrectSystem set;

  # Make the remaining attributes have value equal to their path
  moduleSet = lib.mapAttrsRecursive (path: type: lib.concatStringsSep "/" path) (filterBySystem (readDirRec ./.));

  moduleFiles = builtins.map (path: ./${path}) (lib.collect lib.isString moduleSet);
in
{
  imports = moduleFiles;

  home = {
    username = "kfish";
    homeDirectory = "/home/kfish";

    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;
}
