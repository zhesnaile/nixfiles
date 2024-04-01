{ lib, config, pkgs, ... }:

{
  # xpadneo
  hardware.xpadneo.enable = true;

  # Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" "amdgpu" "hid_xpadneo" ];
}
