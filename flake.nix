{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      klaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/klaptop.nix
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
    };
  };
}
