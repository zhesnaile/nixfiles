{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4e0df140-6891-4ea5-b31d-98040c8634ac";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-6db2a8f7-1782-4085-91e1-83547d7cde9c".device = "/dev/disk/by-uuid/6db2a8f7-1782-4085-91e1-83547d7cde9c";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/5F4A-CEB8";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/019f1547-6dda-4c15-b703-31d69d4c772d"; }
    ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-dbddbc83-70c7-43ac-b550-827d237df53c".device = "/dev/disk/by-uuid/dbddbc83-70c7-43ac-b550-827d237df53c";
  boot.initrd.luks.devices."luks-dbddbc83-70c7-43ac-b550-827d237df53c".keyFile = "/crypto_keyfile.bin";

  environment.etc.crypttab = {
    enable = true;
    text = ''
    fastboi UUID=848c8d5c-dffa-4a01-9716-f8d81abcb41c /etc/nixos/secrets/fastboi.key luks
    bigboi UUID=38a57ba5-2b3a-4756-91d9-1d4d198f04a9 /etc/nixos/secrets/bigboi.key luks
    smallboi UUID=d5d794c9-5aed-49ea-9816-11bc66628679 /etc/nixos/secrets/smolerboi.key luks
    gamelib UUID=929560de-31b3-4958-b310-ed97b3742e15 /etc/nixos/secrets/gamelib.key luks
    '';
    };
  system.activationScripts.makeMediaDirs = ''
    mkdir -p /media/{fastboi,bigboi,smallboi,gamelib}
  '';

  fileSystems = {
    "/media/fastboi" = {
      device = "/dev/mapper/fastboi";
      fsType = "ext4";
    };

    "/media/bigboi" = {
      device = "/dev/mapper/bigboi";
      fsType = "ext4";
    };

    "/media/smallboi" = {
      device = "/dev/mapper/smallboi";
      fsType = "xfs";
    };

    "/media/gamelib" = {
      device = "/dev/mapper/gamelib";
      fsType = "ext4";
    };
  };
}
