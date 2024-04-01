# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secrets
      ./boot.nix
      ./nvidia_prime.nix
    ];

  base.enable = true;
  desktop.enable = true;


  system.stateVersion = "22.11";

}
