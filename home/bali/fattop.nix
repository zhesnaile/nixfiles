{ pkgs, lib, config, ... }:

{
  home.stateVersion = "23.11";
  cli.enable = true;
  manage-plasma.enable = true;
}
