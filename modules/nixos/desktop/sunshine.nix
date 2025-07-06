{ pkgs, lib, config, ...}:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
  sunshineCfg = config.desktop.services.sunshine;
in {
  config = mkIf (cfg.enable && sunshineCfg.enable) {
    services.sunshine ={
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 47984 47989 48010 ];
      allowedUDPPortRanges = [
        { from = 47998; to = 48000; }
        { from = 8000; to = 8010; }
      ];
    };
  };
}

