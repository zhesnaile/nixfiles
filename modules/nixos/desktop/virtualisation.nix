 {lib, pkgs, config, ...}:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      # Enable libvirtd
      libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
        qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
        qemu.swtpm.enable = true;
        onBoot = "ignore";
        qemu.verbatimConfig = ''
        user = "bali"
        '';
      };

      # Enable docker
      docker.enable = true;
    };
  };
}
