{lib, pkgs, config, ...}:

{
  # Enable network manager
  networking.networkmanager.enable = true;
  # Enable fwupd
  services.fwupd.enable = true;
}
