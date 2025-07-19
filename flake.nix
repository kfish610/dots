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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      stylix,
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
            ./modules/base.nix
            ./modules/klaptop.nix

            home-manager.nixosModules.home-manager
            (mkHmModule [ "linux" ])

            {
              home-manager.sharedModules = [ stylix.homeModules.stylix ];
            }
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs.nixos-wsl = nixos-wsl;
          modules = [
            ./modules/base.nix
            ./modules/wsl.nix

            nixos-wsl.nixosModules.default

            home-manager.nixosModules.home-manager
            (mkHmModule [ "linux" ])
          ];
        };
      };
    };
}
