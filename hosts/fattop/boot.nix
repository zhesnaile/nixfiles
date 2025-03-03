{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];

  # Kernel Modules
  # boot.extraModulePackages = with config.boot.kernelPackages;
  #   [ tuxedo-keyboard ];
  # boot.kernelParams = [
  #   "tuxedo_keyboard.mode=0"
  #   "tuxedo_keyboard.color_left=0xEDEE0E"
  #   "tuxedo_keyboard.color_center=0xEDEE0E"
  #   "tuxedo_keyboard.color_right=0xEEEE0E"
  #   "tuxedo_keyboard.brightness=25"
  #   "tuxedo_keyboard.state=0"
  #   "quiet"
  # ];
}
