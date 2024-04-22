# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot.nix
      ./sops.nix
    ];

  base = {
    enable = true;
    hostname = "hothead";
  };

  desktop = {
    enable = true;
    flatpaks = [
      "com.discordapp.Discord"
      "com.heroicgameslauncher.hgl"
      "io.dbeaver.DBeaverCommunity"
      "com.spotify.Client"
      "org.ryujinx.Ryujinx"
      "org.prismlauncher.PrismLauncher"
    ];
  };

  system.stateVersion = "22.11";

}
