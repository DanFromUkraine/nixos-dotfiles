{
  description = "hide.me CLI VPN client for Linux";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    {
      packages = builtins.mapAttrs (system: pkgs: {
        hide-me = pkgs.callPackage ./package.nix { };
        default = self.packages.${system}.hide-me;
      }) nixpkgs.legacyPackages;

      overlays.default = final: prev: {
        hide-me = final.callPackage ./package.nix { };
      };

      nixosModules.hide-me = ./module.nix;
      nixosModules.default = self.nixosModules.hide-me;

      checks = builtins.mapAttrs (system: pkgs: {
        hide-me = self.packages.${system}.hide-me;
      }) nixpkgs.legacyPackages;

      formatter = builtins.mapAttrs (_: pkgs: pkgs.nixfmt) nixpkgs.legacyPackages;
    };
}
