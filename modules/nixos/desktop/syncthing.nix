{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    services = {
      syncthing = {
          enable = true;
          user = "bali";
          dataDir = "/home/bali/Documents/syncthing";
          configDir = "/home/bali/.config/syncthing";
      };
    };

    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
