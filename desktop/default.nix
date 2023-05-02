{ config, ... }:

{
  networking.hostName = "hothead";

  imports =
  [
    ../generic
    ./boot.nix
    ../mystuff
  ];

  security.pam.loginLimits = [
    {domain = "*";type = "-";item = "memlock";value = "infinity";}
    {domain = "*";type = "-";item = "nofile";value = "65536";}
  ];

  specialisation.vfio.configuration = {
    system.nixos.tags = [ "with-vfio" ];
    mystuff.vfio = {
      enable = true;
      iommu-mode = "amd_iommu";
      pci-devs = [
        "1002:731f"
        "1002:ab38"
      ];
      vendor-reset = true;
    };
  };

}
