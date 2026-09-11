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

    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell";
    dank-material-shell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      stylix,
      dank-material-shell,
      ...
    }:
    let
      system = "x86_64-linux";
      mkHmModule = info: {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;

        # Loads default.nix, which then recursively
        # loads the contents of the home folder
        home-manager.users.kfish = import ./home;

        home-manager.extraSpecialArgs = {
          systemInfo = info;
        };
      };

      mkLinuxSystem =
        module: info:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            module

            home-manager.nixosModules.home-manager
            (mkHmModule info)

            stylix.nixosModules.stylix

            { home-manager.sharedModules = [ dank-material-shell.homeModules.dank-material-shell ]; }
          ];
        };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      nixosConfigurations = {
        klaptop = mkLinuxSystem ./modules/klaptop.nix [
          "linux"
          "laptop"
        ];

        kdesktop = mkLinuxSystem ./modules/kdesktop.nix [
          "linux"
          "desktop"
        ];

        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
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
