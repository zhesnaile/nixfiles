{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.gui.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;
    };
  };
}
