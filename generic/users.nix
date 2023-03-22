{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bali = {
    isNormalUser = true;
    description = "bali";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      brave
      lazygit
      fd
      ripgrep
      vscodium
      discord
      spotify
      kitty
      zsh
      rust-analyzer
      nodejs
      python3
      pyright
      poetry
      git
      keepassxc
      haskell-language-server
      #  thunderbird
    ];
  };

}
