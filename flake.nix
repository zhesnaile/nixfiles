# flake.nix
{
  description = "My NixOS & home manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, hardware, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = let lib = nixpkgs.lib // home-manager.lib;
      in {
        inherit lib;

        nixosConfigurations = {
          # main desktop
          hothead = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix

              hardware.nixosModules.common-cpu-amd
              hardware.nixosModules.common-gpu-amd
              hardware.nixosModules.common-pc-ssd
            ];
          };
        };
      };

      # per-system attributes can be defined here. the self' and inputs'
      # module parameters provide easy access to attributes of the same
      # system.
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ git home-manager neovim nix ];

          shellHook = ''
            export NIX_CONFIG="extra-experimental-features = nix-command flakes repl-flake"
          '';
        };

        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
