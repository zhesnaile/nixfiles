{ pkgs, lib, config, ... }: {
  options.mystuff.vfio = with lib; {
    enable = mkEnableOption "Configure the machine for VFIO passthrough";

    iommu-mode = mkOption {
      type = with types; enum [ "amd_iommu" "intel_iommu" ];
      description = ''
        Whether to use AMD or Intel iommu.
      '';
    };

    pci-devs = mkOption {
      type = with types; listOf str;
      description = ''
        A list of PCI IDs in the form "vendor:product" where vendor and product
        are 4-digit hex values.
      '';
    };

    vendor-reset = mkEnableOption "add vendor-reset module if needed";
  };

  config = let cfg = config.mystuff.vfio;
  in lib.mkIf cfg.enable {
    virtualisation.spiceUSBRedirection.enable = true;

    hardware.opengl.enable = true;

    boot = {
      kernelParams = [
        # enable IOMMU
        "${cfg.iommu-mode}=on"
      ] ++
        # isolate the GPU
        lib.optional (builtins.length cfg.pci-devs > 0)
        ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.pci-devs);

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ] ++
      lib.optional (cfg.vendor-reset) "vendor-reset";

      extraModulePackages = with config.boot.kernelPackages; [ vendor-reset ];

    };
  };
}
