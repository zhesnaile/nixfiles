{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb = {
          layout = "es";
          options = "ctrl:nocaps,shift:both_capslock";
      };

    };

    services.libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    services.desktopManager.plasma6.enable = true;
    services.xserver.windowManager.qtile.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.defaultSession = "plasma";

    services.udev.packages = with pkgs; [
      via
      vial
    ];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

    };

    hardware.bluetooth.enable = true;

    services.printing.enable = false;

    networking.firewall = {
      logReversePathDrops = true;
      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
  };
}
