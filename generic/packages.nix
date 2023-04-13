{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install Steam
  programs.steam = {
    enable = true;
  };

  programs.ssh.startAgent = true;

  programs.zsh.enable = true;

  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    htop
    curl
    wget
    virt-manager
    #gnome.gnome-tweaks
    gnumake
    gcc
    killall
    cachix
  ];
}
