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
    {
      nixosConfigurations = {
        klaptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/base.nix
            ./modules/klaptop.nix

            home-manager.nixosModules.home-manager # Not a function call!
            {
              home-manager.useUserPackages = true;
              # Loads default.nix, which then recursively
              # loads the contents of the home folder
              home-manager.users.kfish = import ./home;
              home-manager.extraSpecialArgs = {
                systemInfo = [ "linux" ];
                extraModules = [ stylix.homeModules.stylix ];
              };
            }
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.nixos-wsl = nixos-wsl;
          modules = [
            ./modules/base.nix

            nixos-wsl.nixosModules.default
            {
              networking.hostName = "wsl";

              wsl = {
                enable = true;
                defaultUser = "kfish";
                startMenuLaunchers = true;
                docker-desktop.enable = true;
              };
            }

            home-manager.nixosModules.home-manager # Not a function call!
            {
              home-manager.useUserPackages = true;
              # Loads default.nix, which then recursively
              # loads the contents of the home folder
              home-manager.users.kfish = import ./home;
              home-manager.extraSpecialArgs = {
                systemInfo = [ "wsl" ];
              };
            }
          ];
        };
      };
    };
}
