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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; with mypkgs; [
      firefox
      brave
      vscodium
      discord
      spotify
      gimp
      keepassxc
      kitty
      ark
      ghostscript
      zsh
      fd
      fzf
      ripgrep
      cpustat
      tealdeer
      lazygit
      rust-analyzer
      nodejs
      pyright
      git
      haskell-language-server
    ];
  };

}
