{ lib, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./nvidia_prime.nix
    ];

  base = {
    enable = true;
    hostname = "fattop";
  };

  desktop = {
    enable = true;
    flatpaks = [
      "com.heroicgameslauncher.hgl"
      "io.dbeaver.DBeaverCommunity"
      "com.spotify.Client"
      "org.prismlauncher.PrismLauncher"
      "com.discordapp.Discord"
    ];
  };

  system.stateVersion = "22.11";

}
