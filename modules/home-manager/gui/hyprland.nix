{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.gui;
in {
  config = mkIf (cfg.enable && cfg.hyprland.enable) {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;
    };
  };
}
