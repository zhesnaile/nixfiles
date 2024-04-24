{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf concatStringsSep;
  cfg = config.cli;

  language = name: text: text;
  hasPackage = pname:
    lib.any (p: p ? pname && p.pname == pname) config.home.packages;

  hasRipgrep = hasPackage "ripgrep";
  hasExa = hasPackage "eza";
  hasNeovim = config.programs.neovim.enable;
  hasKitty = config.programs.kitty.enable;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ grc ];

    programs.fish = {
      enable = true;

      shellAbbrs = rec {
        # nix
        nsr = "nix run nixpkgs#";
        nsn = "nix shell nixpkgs#";
        nbn = "nix build nixpkgs#";
        nbp =
          "nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'";
        nrr = "nixos-rebuild-remote";
      };

      # shellAliases = rec {
      #   # Clear screen and scrollback
      #   clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      # };

      functions = {
        # disable greeting
        fish_greeting = "";

        fish_user_key_bindings = language "fish" ''
          # fish_vi_key_bindings

          # use search with tab complete - next best thing to fzf tab completion
          bind --mode insert \t complete-and-search
          bind --mode insert --key btab complete
          bind --mode visual \t complete-and-search
          bind --mode visual --key btab complete
          bind \t complete-and-search
          bind --key btab complete
        '';

        # list all paths in $PATH
        paths = language "fish" ''
          for path in $PATH
          echo -- $path
          end
        '';

        # make a directory and cd into it
        mkcd = language "fish" ''
          mkdir -pv $argv
          cd $argv
        '';

        # renames the current working directory
        mvcd = language "fish" ''
          set cwd $PWD
          set newcwd $argv[1]
          cd ..
          mv $cwd $newcwd
          cd $newcwd
          pwd
        '';

        # quick wrapper to make running `nix develop` without any arguments
        # run Fish instead of Bash.
        nix = {
          wraps = "nix";
          description = "Wraps `nix develop` to run fish instead of bash";
          body = language "fish" ''
            if status is-interactive
            and test (count $argv) = 1 -a "$argv[1]" = develop

                # Special case: if there's an initialized .flake directory, use that.
                if test -d .flake -a -f .flake/flake.nix
                announce nix develop $PWD/.flake --command (status fish-path)
                else
                announce nix develop --command (status fish-path)
                end

                else
                command nix $argv
                end
          '';
        };

        nd = {
          wraps = "nix develop";
          description = "Wraps `nix develop` to run fish instead of bash";
          body = language "fish" ''
            if status is-interactive
            nix develop $argv -c $SHELL
            end
          '';
        };


        # grep using ripgrep and pass to nvim
        nvimrg =
          mkIf (hasNeovim && hasRipgrep) "nvim -q (rg --vimgrep $argv | psub)";

        # prints the command to the screen, colorized it would be when executed
        # at the command line, then executes the command.
        # this is meant to look like the user is executing the command, while
        # also making it clear it's happening automatically. Useful for functions
        # where it's just some simple commands being run in sequence.
        announce = language "fish" ''
          set colored_command (echo -- "$argv" | fish_indent --ansi)
          echo "$(set_color magenta)~~>$(set_color normal) $colored_command"
          $argv
        '';

        # why's it called 'o'? because it's really good ;)
        # i'm joking, it's just because it's on my home row (colemak layout)
        o = {
          wraps = "cd";
          description = "Interactive cd that offers to create directories";
          body = language "fish" ''
            # Some git trickery first. If the function is called with no arguments,
            # typically that means to cd to $HOME, but we can be smarter - if you're
            # in a git repo and not in its root, cd to the root.
            if test (count $argv) -eq 0
            set git_root (git rev-parse --git-dir 2>/dev/null | path dirname)
            if test $status -eq 0 -a "$git_root" != .
            cd $git_root
            return 0
            end
            end

            # Now that's out of the way
            cd $argv
            set cd_status $status
            if test $cd_status -ne 0
            and gum confirm "Create the directory? ($argv[-1])"
            echo "Creating directory"
            command mkdir -p -- $argv[-1]
            builtin cd $argv[-1]
            return 0
            else
            return $cd_status
            end
          '';
        };

        # cd to a temporary directory
        tcd = language "fish" ''
          cd (mktemp -d)
        '';
      };

      plugins = with pkgs;
        with fishPlugins; [
          {
            name = "fisher";
            src = fetchFromGitHub {
              owner = "jorgebucaran";
              repo = "fisher";
              rev = "2efd33ccd0777ece3f58895a093f32932bd377b6";
              sha256 = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
            };
          }
          {
            name = "dracula";
            src = fetchFromGitHub {
              owner = "dracula";
              repo = "fish";
              rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
              sha256 = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
            };
          }
          {
            name = "coloured-man-pages";
            src = colored-man-pages.src;
          }
          {
            name = "fzf-fish";
            src = fzf-fish.src;
          }
        ];

      interactiveShellInit = ''
        # theme
        fish_config theme choose "Dracula Official"

        # kitty integration
        set --global KITTY_INSTALLATION_DIR "${pkgs.kitty}/lib/kitty"
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"

        # use vim cursors
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block

        # fzf config
        set fzf_diff_highlighter delta --paging=never --width=20
        fzf_configure_bindings --directory=\co

        # sponge clears typos from history when shell exits
        set sponge_purge_only_on_exit true

        # done config
        set __done_min_cmd_duration 10000 # 10 seconds

        # use fish for nix shells
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
      '';

      shellInit = language "fish" ''
        # source local env variables
        if test -f ${config.xdg.configHome}/fish/env.local.fish;
        source ${config.xdg.configHome}/fish/env.local.fish
        end

        if test -f ${config.xdg.configHome}/fish/env.secrets.fish;
        source ${config.xdg.configHome}/fish/env.secrets.fish
        end
      '';
    };

  };
}
