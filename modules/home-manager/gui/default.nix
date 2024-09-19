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
    enable = lib.mkEnableOption "Enable desktop configuration";

    packages = mkOption {
      type = listOf package;
      default = [ ];
      description = "CLI packages to include";
    };
  };

}

