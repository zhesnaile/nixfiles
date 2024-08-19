{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    # xorg related settings
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

    # Enable sound with pipewire.
    #sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    #networking.firewall.allowedTCPPorts = [ ];
    #networking.firewall.allowedUDPPorts = [ ];
    # Or disable the firewall altogether.
    networking.firewall = {
      # if packets are still dropped, they will show up in dmesg
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
