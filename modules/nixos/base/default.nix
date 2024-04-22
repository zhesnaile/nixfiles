{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkDefault mkOption mkEnableOption optional;
  inherit (config.networking) hostName;
  inherit (builtins) map;
  cfg = config.base;

in {
  imports =
    [ ./nix.nix ./packages.nix ./security.nix ./services.nix ];

  options.base = with lib.types; {
    enable = mkEnableOption "Enable the base system module.";
    hostname = mkOption {
      type = str;
      default = "nixos";
      description = "The hostname of the machine.";
    };

    primaryUser = mkOption {
      type = str;
      default = "bali";
      description = "Primary user for permissions and defaults.";
    };

    tz = mkOption {
      type = str;
      default = "Europe/Madrid";
      description = "The timezone of the machine.";
    };

    fs = {
      btrfs = mkOption {
        type = bool;
        default = false;
        description = "Enable btrfs support.";
      };
      zfs = mkOption {
        type = bool;
        default = false;
        description = "Enable zfs support.";
      };
    };

    autoupdate = mkOption {
      type = bool;
      default = true;
      description = "Enable automatic updates.";
    };
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostname;

    time.timeZone = mkDefault cfg.tz;

    # basic packages
    # sops
    #sops = let
    #  isEd25519 = k: k.type == "ed25519";
    #  getKeyPath = k: k.path;
    #  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
    #in { age.sshKeyPaths = map getKeyPath keys; };

    # defaults
    networking.networkmanager.enable = mkDefault true;
    hardware.enableRedistributableFirmware = mkDefault true;
    services.btrfs.autoScrub.enable = mkDefault cfg.fs.btrfs;
    services.zfs.autoSnapshot.enable = mkDefault cfg.fs.zfs;
    services.zfs.autoScrub.enable = mkDefault cfg.fs.zfs;
    services.geoclue2.enable = mkDefault true;
    i18n.defaultLocale = mkDefault "en_US.UTF-8";
    i18n.supportedLocales =
      mkDefault [ "es_ES.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
    };


    # boot config
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = mkDefault 3;
          consoleMode = "max";
        };
        timeout = mkDefault 1;
        efi.canTouchEfiVariables = true;
      };

      plymouth = {
        enable = true;
        theme = "colorful_loop";
        themePackages = with pkgs; [ adi1090x-plymouth-themes ];
      };

      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];

      supportedFilesystems = (optional cfg.fs.btrfs "btrfs")
        ++ (optional cfg.fs.zfs "zfs");
      zfs.forceImportRoot = mkIf cfg.fs.zfs (mkDefault false);
      consoleLogLevel = 0;
      initrd.verbose = false;
    };

    console = {
      keyMap = mkDefault "es";
      useXkbConfig = true;
      earlySetup = mkDefault false;
    };

    # Only run if current config (self) is older than the new one.
    systemd.services.nixos-upgrade = lib.mkIf config.system.autoUpgrade.enable {
      serviceConfig.ExecCondition = lib.getExe
        (pkgs.writeShellScriptBin "check-date" ''
          lastModified() {
            nix flake metadata "$1" --refresh --json | ${
              lib.getExe pkgs.jq
            } '.lastModified'
          }
          test "$(lastModified "${config.system.autoUpgrade.flake}")"  -gt "$(lastModified "self")"
        '');
    };
  };
}
