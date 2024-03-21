{ config, pkgs, ... }:
let
  mypkgs = import (fetchTarball "https://github.com/zhesnaile/nixpkgs/archive/main.tar.gz") { };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bali = {
    isNormalUser = true;
    description = "bali";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; with mypkgs;
    ## GUI APPS
    [
      firefox
      brave
      chromium
      vscodium
      spotify
      gimp
      mpv
      keepassxc
      kitty
      ark
      mangohud
      easyeffects
      rpcs3
      dolphin-emu
      ppsspp-qt
      protonup-qt
      gamescope
      libreoffice-qt
      remmina
      blender
      aseprite-unfree
      godot_4
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
      python3
      tmux
      tmux-xpanes
      terraform
      ansible
      tree
      lm_sensors
    ]
    ++
    ## dependencies
    [
      hunspell
      hunspellDicts.es_ES
      hunspellDicts.en_GB-ise
      hunspellDicts.fr-any
      ghostscript
      lazygit
      rust-analyzer
      nodejs
      pyright
      xclip
      p7zip
      luajit
      cowsay
      fortune
    ];
  };

}
