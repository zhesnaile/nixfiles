{ pkgs, lib, config, ...}:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    # increase open file limit for sudoers
    security.pam.loginLimits = mkDefault [
      {
        domain = "@wheel";
        item = "nofile";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@wheel";
        item = "nofile";
        type = "hard";
        value = "1048576";
      }
    ];
  };

}

