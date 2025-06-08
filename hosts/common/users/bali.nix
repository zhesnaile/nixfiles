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
      firefox
      discord
      ungoogled-chromium
      vscodium
      spotify
      gimp
      mpv
      keepassxc
      kitty
      mangohud
      easyeffects
      dolphin-emu
      ppsspp-qt
      protonup-qt
      gamescope
      libreoffice-qt
      jellyfin-media-player
      virt-manager
      calibre
      wireshark-qt
      handbrake
    ]
    ++
    ## cli apps
    [
      zsh
      fd
      fzf
      ripgrep
      tealdeer
      git
      python3
      tmux
      tmux-xpanes
      opentofu
      ansible
      tree
      lm_sensors
      dig
      gh
      xxHash
      ani-cli
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
      wl-clipboard
      p7zip
      unzip
      luajit
      cowsay
      fortune
    ];
  };

  home-manager.users.bali = import ../../../home/bali/${config.networking.hostName}.nix;
}
