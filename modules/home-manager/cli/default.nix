{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.cli;
in {
  imports = [
    ./neovim.nix
    ./fish.nix
    ./programs.nix
  ];

  options.cli = let inherit (lib) mkEnableOption mkOption;
  in with lib.types; {
    enable = lib.mkEnableOption "Enable desktop configuration";

    packages = mkOption {
      type = listOf package;
      default = [ ];
      description = "CLI packages to include";
    };

    aliases = mkOption {
      type = attrsOf str;
      default = { };
      description = "Shell aliases";
      example = {
        ls = "exa";
        la = "exa -la";
      };
    };

    env = mkOption {
      type = attrsOf str;
      default = { };
      description = "Environment variables";
      example = { ENV_VARIABLES = "values"; };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          comma # install and run programs by sticking a , before them
          distrobox # nice escape hatch, integrates docker images with my environment

          age # encryption
          atool # work with archives
          bitwarden-cli # password manager
          cachix # nix binary cache manager
          cowsay # ascii art
          diffsitter # better diff
          dogdns # better dig
          dua # better du
          fd # better find
          fx # better jq
          figlet # ascii art
          ffmpeg # media multitool
          ffmpegthumbnailer # thumbnailer
          httpie # better curl
          lsb-release # get distro info
          manix # nix documentation tool
          mediainfo # media info
          navi # cheatsheet
          nil # nix LSP
          nixd # nix LSP
          nixfmt-classic # nix formatter
          # nix-delegate # distributed nix builds transparently
          #nix-du # du for nix store
          nix-inspect # see which pkgs are in your PATH
          packagekit # package helper across distros
          pfetch # system info
          playerctl # media player controller
          # poetry # python package manager
          prettyping # better ping
          p7zip # zip archiver
          rage # age with rust
          ranger # file manager
          rclone # cloud storage manager
          rsync # file transfer
          sd # better sed
          sshfs # mount remote filesystems
          steam-run # run binaries in fhs
          timer # to help with my ADHD paralysis
          tokei # count lines of code in project
          urlencode # url encoder
          xclip # clipboard manager
          xdg-utils # xdg-open
          xdo # xdotool
          todoist # todo app client
          yq-go # jq for yaml
          vulnix # nix security checker
          zip # archiver

          # personal packages
        ] ++ cfg.packages;

      shellAliases = let
        hasPackage = pname:
          lib.any (p: p ? pname && p.pname == pname) config.home.packages;
        hasRipgrep = hasPackage "ripgrep";
        hasExa = hasPackage "eza";
        hasNeovim = config.programs.neovim.enable;
        hasKitty = config.programs.kitty.enable;
      in rec {
        # main aliaes
        ls = "eza";
        la = "${ls} -al";
        ll = "${ls} -l";
        l = "${ls} -l";

        mkd = "mkdir -pv";
        mv = "mv -v";
        rm = "rm -i";

        vim = "nvim";
        vi = vim;
        v = vim;
        svim = "sudo -e";

        grep = "grep --color=auto";
        diff = "diff --color=auto";
        ip = "ip --color=auto";

        src = "exec $SHELL";

        # nix
        n = "nix-shell -p";
        nb = "nix build";
        # nd = "nix develop -c $SHELL";
        ndi = "nix develop --impure -c $SHELL";
        ns = "nix shell";
        nf = "nix flake";
        flakeup =
          "nix flake update --update-input nixpkgs --update-input home-manager";

        # build nixos iso file
        nbsiso = "nix build .#nixosConfigurations.nixiso.config.formats.iso";

        # home manager
        hm = "home-manager --flake $FLAKE";
        hmsb = "${hm} switch -b backup";
        hmb = "${hm} build";
        hmn = "${hm} news";

        hms = "${pkgs.nh}/bin/nh home switch";

        # replacements
        cat = mkIf (hasPackage "bat") "bat";
        dia = mkIf (hasPackage "dua") "dua interactive";
        ping = mkIf (hasPackage "prettyping") "prettyping";
        ssh = mkIf hasKitty "kitty +kitten ssh";

        # general aliaes
        cik = "clone-in-kitty --type os-window";
        ck = cik;
        dirties = "watch -d grep -e Dirty: -e Writeback: /proc/meminfo";
        jc = "journalctl -xeu";
        jcu = "journalctl --user -xeu";
        jqless = "jq -C | less -r";
        ly =
          "lazygit --git-dir=$HOME/.local/share/yadm/repo.git --work-tree=$HOME";
        md = "frogmouth";
        neofetchk = "neofetch --backend kitty --source $HOME/.config/wall.png";
        "inodes-where" =
          "sudo du --inodes --separate-dirs --one-file-system / | sort -rh | head";
        ps_mem = "sudo ps_mem";
        rcp = "rclone copy -P --transfers=20";
        rgu = "rg -uu";
        rsync = "rsync --info=progress2 -r";
        xclip = "xclip -selection c";
        vrg = mkIf (hasNeovim && hasRipgrep) "nvimrg";

        # fun
        expand-dong = "aunpack";
        starwars = "telnet towel.blinkenlights.nl";
      } // cfg.aliases;

      sessionVariables = {
        DIRENV_LOG_FORMAT = "";
        KUBECONFIG = "${config.xdg.configHome}/kube/config";
        PF_INFO =
          "ascii title os kernel uptime shell term desktop scheme palette";
        RANGER_LOAD_DEFAULT_RC = "FALSE";
      } // cfg.env;
    };

    programs = {
      bash = { enable = true; };

      mcfly = {
        enable = true;

        keyScheme = "vim";
      };

      zoxide.enable = true;
    };
  };
}

