{ inputs, pkgs, config, ... }:

{
  imports = [
    # import users
    ./users/bali.nix
  ];

  # sops
  #sops.defaultSopsFile = ./secrets.yaml;
}
