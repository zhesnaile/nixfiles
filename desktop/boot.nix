{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  # xpadneo
  hardware.xpadneo.enable = true;

  # Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" "amdgpu" "hid_xpadneo" ];

}
