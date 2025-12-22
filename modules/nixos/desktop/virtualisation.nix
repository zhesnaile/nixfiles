 {lib, pkgs, config, ...}:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
        onBoot = "ignore";
        qemu.verbatimConfig = ''
        user = "bali"
        '';
      };

      docker.enable = true;
    };
  };
}
