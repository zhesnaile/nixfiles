{ pkgs, lib, config, ... }:

let
  cfg = config.base;
  inherit (lib) mkIf mkDefault;
in {

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    security.apparmor.enable = mkDefault true;
    security.apparmor.killUnconfinedConfinables = mkDefault true;

    services.clamav.daemon.enable = true;
    services.clamav.updater.enable = true;

    security.sudo.enable = true;

  };
}
