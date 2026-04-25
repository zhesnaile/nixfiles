{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.cli;
in {
  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    programs.neovim = {
      enable = true;

        #package = pkgs.neovim-nightly;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      initLua = ''
        -- bootstrap lazy.nvim, lazyvim and my plugins
        require('config.lazy')
      '';

      extraPackages = with pkgs; [
        cargo
        gcc
        gnumake
        go
        nixfmt
        shellcheck

        # language servers & mason binaries
        buf
        clang-tools
        docker-compose-language-service
        dockerfile-language-server
        lua-language-server
        rust-analyzer
        pyright
        yaml-language-server
      ];
    };
  };
}
