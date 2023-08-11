{ pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install Steam
  programs.steam = {
    enable = true;
  };

  # ssh agent
  programs.ssh.startAgent = true;

  # zsh shell
  programs.zsh.enable = true;

  # dconf, needed for virt-manager
  programs.dconf.enable = true;

  # kde connect
  programs.kdeconnect.enable = true;

  # kde partition manager
  programs.partition-manager.enable = true;

  # add development docs
  # documentation.dev.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # exclude packages bundled with kde
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    oxygen
    print-manager
    plasma-browser-integration
    konsole
  ];

  environment.systemPackages = with pkgs; [
    neovim
    htop
    curl
    wget
    virt-manager
    kate
    #gnome.gnome-tweaks
    gnumake
    gcc
    killall
    cachix
    docker-compose
    nmon
    man-pages
    man-pages-posix
  ];
}
