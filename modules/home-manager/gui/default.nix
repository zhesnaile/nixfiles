{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.gui;
in {
  imports = [
    ./hyprland.nix
  ];
  options.gui = let inherit (lib) mkEnableOption mkOption;
  in with lib.types; {
    enable = lib.mkEnableOption "Enable desktop GUI configuration";
  };
}

