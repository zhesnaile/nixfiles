{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    # Enable syncthing
    services = {
      syncthing = {
          enable = true;
          user = "bali";
          dataDir = "/home/bali/Documents/syncthing";    # Default folder for new synced folders
          configDir = "/home/bali/.config/syncthing";   # Folder for Syncthing's settings and keys
      };
    };

    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
