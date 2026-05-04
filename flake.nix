{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: 
  let
    powerProfile = "performance"; # performance or eco 
  in {
      nixosConfigurations.linkava = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs powerProfile; }; 
        
        modules = [
          ./src/configuration.nix

          home-manager.nixosModules.home-manager
          {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.extraSpecialArgs = { inherit powerProfile; };
           home-manager.users.linkava = import ./src/home.nix; 
          }
        ];
      };
  };
}