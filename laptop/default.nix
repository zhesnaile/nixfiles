{ config, ... }:

{
  networking.hostName = "fattop";

  imports =
    [
      ../generic
      ./boot.nix
      ./nvidia_prime.nix
      ./services.nix
      ../cachix.nix
    ];
}
