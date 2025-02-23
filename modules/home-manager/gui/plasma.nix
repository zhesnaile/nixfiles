{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.gui;
in {
  config = mkIf (cfg.enable && cfg.plasma.enable)  {
    programs.plasma = {
      enable = true;
      shortcuts = {
        "services/kitty.desktop"."_launch" = "Ctrl+Alt+T";
        "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
        "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
        "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
        "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
        "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
        "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
        "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
        "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
        "services/org.kde.spectacle.desktop"."ActiveWindowScreenShot" = "Meta+Print";
        "services/org.kde.spectacle.desktop"."FullScreenScreenShot" = "Shift+Print";
        "services/org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = "Alt+Print";
        "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = [ "Meta+Shift+S" "Meta+Shift+Print"];
        "services/org.kde.spectacle.desktop"."WindowUnderCursorScreenShot" = "Meta+Ctrl+Print";
        "services/org.kde.spectacle.desktop"."_launch" = "Print";
      };
    };
  };
}
