{ config, ... }:

{
  networking.hostName = "hothead";

  imports =
  [
    ../generic/import.nix
    ./boot.nix
    ../mystuff
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
