{ config, ... }:
{
  imports =
    [
      ./packages.nix
      ./users.nix
      ./services.nix
    ];
}
