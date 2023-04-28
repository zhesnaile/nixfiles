{ config, pkgs, ... }:
let
  mypkgs = import (fetchTarball "https://github.com/zhesnaile/nixpkgs/archive/main.tar.gz") { };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bali = {
    isNormalUser = true;
    description = "bali";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; with mypkgs;
    ## GUI APPS
    [
      firefox
      brave
      vscodium
      spotify
      gimp
      mpv
      keepassxc
      kitty
      ark
      mangohud
      easyeffects
    ]
    ++
    ## cli apps
    [
      zsh
      fd
      fzf
      ripgrep
      cpustat
      tealdeer
      git
    ]
    ++
    ## dependencies
    [
      ghostscript
      lazygit
      rust-analyzer
      nodejs
      pyright
      xclip
    ];
  };

}
