{ ... }:

{
  programs.zsh = {
    dirHashes = {
      win = "/mnt/c/Users/kfish";
    };
    shellAliases = {
      "link-desktop-files" =
        "sudo ln -s /home/kfish/.nix-profile/share/applications/*.desktop /usr/share/applications/";
    };
  };
}
