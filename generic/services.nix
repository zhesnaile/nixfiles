{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # xorg related settings
  services.xserver = {
    enable = true;
    xkb = {
        layout = "es";
        options = "ctrl:nocaps,shift:both_capslock";
    };

    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasma";

    libinput.enable = true;
    libinput.touchpad.disableWhileTyping = true;
  };

  services.desktopManager.plasma6.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  virtualisation = {
    # Enable libvirtd
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
      qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
      qemu.swtpm.enable = true;
      onBoot = "ignore";
      qemu.verbatimConfig = ''
      user = "bali"
      '';
    };

    # Enable docker
    docker.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
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

  # Enable syncthing
  services = {
    syncthing = {
        enable = true;
        user = "bali";
        dataDir = "/home/bali/Documents/syncthing";    # Default folder for new synced folders
        configDir = "/home/bali/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
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
}
