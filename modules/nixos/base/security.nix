{ pkgs, lib, config, ... }:

let
  cfg = config.base;
  inherit (lib) mkIf mkDefault;
in {

  config = mkIf cfg.enable {
    # enable polkit
    security.polkit.enable = true;
    # enable apparmor
    security.apparmor.enable = mkDefault true;
    security.apparmor.killUnconfinedConfinables = mkDefault true;

    # enable clamav antivirus 
    services.clamav.daemon.enable = true;
    services.clamav.updater.enable = true;

    # pwless sudo
    security.sudo.enable = true;

  };
}
