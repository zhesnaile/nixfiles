{lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  cfg = config.base;
in {
  config = mkIf cfg.enable {
    # Install Steam
    programs.steam = {
      enable = true;
    };

    # ssh agent
    programs.ssh.startAgent = true;

    # zsh shell
    programs.zsh.enable = true;

    # fish shell
    programs.fish.enable = true;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-extra
      noto-fonts-emoji
      nerd-fonts.fira-mono
      nerd-fonts.hack
      nerd-fonts.inconsolata
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.noto
      liberation_ttf
    ];

    environment.systemPackages = with pkgs; [
      cachix
      curl
      git
      htop
      killall
      man-pages
      man-pages-posix
      neovim
      ps_mem
      wget
    ];

  };
}
