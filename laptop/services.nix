{ config, ... }:

{
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Waydroid
  # virtualisation = {
  #   waydroid.enable = true;
  #   lxd.enable = true;
  # };

  # Enable touchegg
  services.touchegg.enable = true;
}
