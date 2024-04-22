{ pkgs, config, ... }:

let
  inherit (builtins) filter hasAttr readFile;
  ifTheyExist = groups:
    filter (group: hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = true;
  users.users.bali = {
    description = "Carlos";
    isNormalUser = true;
    #hashedPasswordFile = config.sops.secrets.bali-pw.path;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" ] ++ ifTheyExist [
      "docker"
      "input"
      "libvirtd"
      "network"
      "networkmanager"
      "wireshark"
    ];

    #openssh.authorizedKeys.keys = [ (readFile ../../../home/bali/ssh.pub) ];

    packages = with pkgs; [
      home-manager
      ## GUI APPS
      hoppscotch
      obsidian
      slack
      firefox
      brave
      chromium
      vscodium
      spotify
      gimp
      mpv
      keepassxc
      kitty
      ark
      mangohud
      easyeffects
      dolphin-emu
      ppsspp-qt
      protonup-qt
      gamescope
      libreoffice-qt
      remmina
      blender
      libresprite
      godot_4
      jellyfin-media-player
    ]
    ++
    ## cli apps
    [
      zsh
      fd
      fzf
      ripgrep
      #cpustat
      tealdeer
      git
      python3
      tmux
      tmux-xpanes
      terraform
      ansible
      tree
      lm_sensors
      dig
      gh
    ]
    ++
    ## dependencies
    [
      hunspell
      hunspellDicts.es_ES
      hunspellDicts.en_GB-ise
      hunspellDicts.fr-any
      ghostscript
      lazygit
      rust-analyzer
      nodejs
      pyright
      #xclip
      wl-clipboard
      p7zip
      luajit
      cowsay
      fortune
    ];
  };

  #sops.secrets.bali-pw.neededForUsers = true;

  #home-manager.users.bali =
  #  import ../../../home/bali/${config.networking.hostName}.nix;
}
