{lib, pkgs, config, ...}:

{
  # Enable network manager
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  # Enable fwupd
  services.fwupd.enable = true;
}
