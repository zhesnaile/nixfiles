{ config, pkgs, ... }:
let
  mypkgs = import (fetchTarball "https://github.com/zhesnaile/nixpkgs/archive/master.tar.gz") { };
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
      lazygit
      fd
      ripgrep
      vscodium
      discord-ptb
      spotify
      keepassxc
      libreoffice
      cpustat
      kitty
      ark
      ghostscript
      zsh
      tealdeer
      rust-analyzer
      nodejs
      python3
      pyright
      poetry
      git
      haskell-language-server
      ghc
      #  thunderbird
    ];
  };

}
