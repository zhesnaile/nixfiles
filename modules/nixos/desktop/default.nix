{ inputs, pkgs, lib, config, ... }:

let
  cfg = config.desktop;
  inherit (lib) mkIf mkOption mkEnableOption;
in {
  imports = [
    ./security.nix
    ./services.nix
    ./syncthing.nix
    ./virtualisation.nix
  ];

  options.desktop = with lib.types; {
    enable = mkEnableOption "Enable the desktop environment module.";

    isLaptop = mkOption {
      type = bool;
      default = false;
      description = "Enable laptop-specific settings.";
    };

    apps = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Desktop applications to install";
    };

    flatpaks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Flatpaks to install";
    };

  };
  config = let inherit (lib) concatStringsSep mkDefault optional;
  in mkIf cfg.enable {

    # desktop apps
    environment.systemPackages = with pkgs;
      [
        neovim
        htop
        curl
        wget
        killall
        cachix
        man-pages
        man-pages-posix
        # other packages
        fontforge
        via
        vial
      ] ++ cfg.apps;



    # flatpak config
    services.flatpak = {
      enable = true;

      packages = cfg.flatpaks;

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal ];
      config = { common.default = "*"; };
    };

    # font config
    fonts = {
      fontconfig = {
        enable = true;

        defaultFonts = {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };

      fontDir.enable = true;

      packages = with pkgs; [
        cantarell-fonts
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "Hack"
            "Inconsolata"
            "JetBrainsMono"
            "NerdFontsSymbolsOnly"
            "Noto"
          ];
        })
        jetbrains-mono
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
      ];
    };

    # defaults
    programs = {
      #adb.enable = mkDefault true;
      dconf.enable = mkDefault true;
      gamemode.enable = true;
      gnupg.agent.enable = true;
      kdeconnect.enable = mkDefault true;
      #nix-ld.enable = mkDefault true;
      partition-manager.enable = true;
      steam.enable = true;
    };

    services = {
      printing.enable = mkDefault true;
      touchegg.enable = mkDefault cfg.isLaptop;
    };

    hardware = {
      bluetooth.enable = mkDefault true;
      bluetooth.powerOnBoot = mkDefault true;
      graphics.enable = mkDefault true;
    };

    # audio config (pipewire)
    #sound.enable = true;
    security.rtkit.enable = true;
    hardware.pulseaudio.enable = false;

    services.pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
      # jack.enable = true;
    };

    # fix for qt6 plugins
    # environment.profileRelativeSessionVariables = {
    #   QT_PLUGIN_PATH = mkDefault [ "/lib/qt-6/plugins" ];
    # };
    #
    home-manager =
    let
      home-common = import ../../home-manager;
      modules = builtins.attrValues home-common;
    in
    {
      sharedModules = modules ++ [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
      useGlobalPkgs = true;
    };
  };
}
