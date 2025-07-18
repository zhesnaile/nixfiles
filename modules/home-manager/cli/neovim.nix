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

      extraLuaConfig = ''
        -- bootstrap lazy.nvim, lazyvim and my plugins
        require('config.lazy')
      '';

      extraPackages = with pkgs; [
        cargo
        gcc
        gnumake
        go
        nixfmt-classic
        shellcheck

        # language servers & mason binaries
        buf
        clang-tools
        deno
        docker-compose-language-service
        dockerfile-language-server-nodejs
        hadolint
        helm-ls
        lldb
        luajitPackages.jsregexp
        lua-language-server
        rust-analyzer
        nodePackages.bash-language-server
        nodePackages.prettier
        pyright
        nodePackages.typescript-language-server
        python3Packages.debugpy
        shfmt
        stylua
        tailwindcss-language-server
        yaml-language-server
        vscode-langservers-extracted
      ];
    };
  };
}
