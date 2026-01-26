{
  description = "kfish610's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake.url = "github:sodiboo/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";

    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell";
    dank-material-shell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      stylix,
      niri-flake,
      dank-material-shell,
      ...
    }:
    let
      system = "x86_64-linux";
      mkHmModule = info: {
        home-manager.useUserPackages = true;

        # Loads default.nix, which then recursively
        # loads the contents of the home folder
        home-manager.users.kfish = import ./home;

        home-manager.extraSpecialArgs = {
          systemInfo = info;
        };
      };
    in
    {
      nixosConfigurations = {
        klaptop = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./modules/klaptop.nix

            home-manager.nixosModules.home-manager
            (mkHmModule [
              "linux"
              "laptop"
            ])

            stylix.nixosModules.stylix
            niri-flake.nixosModules.niri

            { home-manager.sharedModules = [ dank-material-shell.homeModules.dank-material-shell ]; }
          ];
        };

        kdesktop = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./modules/kdesktop.nix

            home-manager.nixosModules.home-manager
            (mkHmModule [
              "linux"
              "desktop"
            ])

            stylix.nixosModules.stylix
            niri-flake.nixosModules.niri

            { home-manager.sharedModules = [ dank-material-shell.homeModules.dank-material-shell ]; }
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs.nixos-wsl = nixos-wsl;
          modules = [
            ./modules/wsl.nix

            nixos-wsl.nixosModules.default

            home-manager.nixosModules.home-manager
            (mkHmModule [ "wsl" ])
          ];
        };
      };
    };
}
