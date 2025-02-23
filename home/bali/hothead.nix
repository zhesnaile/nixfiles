{ pkgs, lib, config, ... }:

{
  home.stateVersion = "23.11";
  cli.enable = true;
  gui = {
    enable = true;
    hyprland.enable = false;
    plasma.enable = false;
  };
  home.packages = with pkgs; [ ];
}
