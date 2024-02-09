{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }: {
    nixosConfigurations = {
      klaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./modules/klaptop.nix
          home-manager.nixosModules.home-manager # Not a function call!
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Loads default.nix, which then recursively 
            # loads the contents of the home folder
            home-manager.users.kfish = import ./home;
            home-manager.extraSpecialArgs = { systemInfo = [ "linux" ]; };
          }
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.nixos-wsl = nixos-wsl;
        modules = [
          ./configuration.nix
          ./modules/wsl.nix
          home-manager.nixosModules.home-manager # Not a function call!
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Loads default.nix, which then recursively 
            # loads the contents of the home folder
            home-manager.users.kfish = import ./home;
            home-manager.extraSpecialArgs = { systemInfo = [ "wsl" ]; };
          }
        ];
      };
    };
  };
}
