{lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
in {
  config = mkIf config.base.enable {
    # Install Steam
    programs.steam = {
      enable = true;
    };

    programs.gamemode.enable = true;

    # ssh agent
    programs.ssh.startAgent = true;

    # zsh shell
    programs.zsh.enable = true;

    # fish shell
    programs.fish.enable = true;

    # dconf, needed for virt-manager
    programs.dconf.enable = true;

    # kde connect
    programs.kdeconnect.enable = true;

    # kde partition manager
    programs.partition-manager.enable = true;

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
  };
}
