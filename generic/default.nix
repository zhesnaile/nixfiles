{ config, ... }:
{
  imports =
    [
      ./packages.nix
      ./users.nix
      ./services.nix
      ./hardened.nix
      ./command.nix
    ];
}
