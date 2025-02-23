{ inputs, pkgs, lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.base;
in {

  config = mkIf cfg.enable {
    nix = {
      settings = {
        trusted-users = [ "root" "@wheel" "bali" ];
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://devenv.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];
        auto-optimise-store = lib.mkDefault true;
        warn-dirty = true;
        system-features = [ "kvm" "big-parallel" "nixos-test" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 5d";
      };

      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
    };
  };
}

