{ config, ... }:

{
  networking.hostName = "hothead";

  imports =
    [
      ../generic/import.nix
      ./boot.nix
    ];
}
