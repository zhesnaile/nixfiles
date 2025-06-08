{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-6a5c865c-801f-486c-ab78-924a6f9b30cd".device = "/dev/disk/by-uuid/6a5c865c-801f-486c-ab78-924a6f9b30cd";

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
}
