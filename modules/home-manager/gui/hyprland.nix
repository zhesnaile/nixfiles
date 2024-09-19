let
  inherit (lib) mkIf;
  cfg = config.gui;
in {
  config = mkIf cfg.enable {
    home = {
      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
        systemd.enable = true;
      };
    };
  };
}
