{ config, ... }:

{
  networking.hostName = "fattop";

  imports =
    [
      ../generic/import.nix
      ./boot.nix
      ./nvidia_prime.nix
      ./services.nix
    ];
}
