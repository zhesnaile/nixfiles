{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.gui;
in {
  imports = [
    ./hyprland.nix
    ./plasma.nix
  ];

  options.gui = let inherit (lib) mkEnableOption mkOption;
  in with lib.types; {
    enable = lib.mkEnableOption "Enable desktop GUI configuration";

    hyprland.enable = lib.mkEnableOption "Enable hyprland configuration";

    plasma.enable = lib.mkEnableOption "manage plasma config with Home-manager";
  };
   config.gui = {
      enable = mkDefault true;
      hyprland.enable = mkDefault false;
      plasma.enable = mkDefault false;
  };
}

