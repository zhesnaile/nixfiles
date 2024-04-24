# flake.nix
{
  description = "My NixOS & home manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, hardware, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = let lib = nixpkgs.lib // home-manager.lib;
      in {
        inherit lib;
        nixosModules = import modules/nixos;

        nixosConfigurations = {
          # main desktop
          hothead = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ./hosts/hothead
              ./hosts/common
              self.nixosModules.base
              self.nixosModules.desktop

              hardware.nixosModules.common-cpu-amd
              hardware.nixosModules.common-gpu-amd
              hardware.nixosModules.common-pc-ssd

              home-manager.nixosModules.home-manager

              inputs.sops-nix.nixosModules.sops
              inputs.nix-flatpak.nixosModules.nix-flatpak
            ];
          };

          fattop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ./hosts/fattop
              ./hosts/common
              self.nixosModules.base
              self.nixosModules.desktop

              hardware.nixosModules.common-cpu-intel
              hardware.nixosModules.common-gpu-nvidia
              hardware.nixosModules.common-pc-laptop-ssd

              home-manager.nixosModules.home-manager

              inputs.sops-nix.nixosModules.sops
              inputs.nix-flatpak.nixosModules.nix-flatpak
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
