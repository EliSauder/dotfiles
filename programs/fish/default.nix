{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.fish;
in
{
  options.prog = {
    fish.enable = lib.mkEnableOption "Enable fish";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.grc
      pkgs.fzf
      pkgs.fd
      pkgs.bat
    ];

    xdg.configFile."fish/themes/Catppuccin Mocha.theme".text = ''
      # name: 'Catppuccin Mocha'
      # url: 'https://github.com/catppuccin/fish'
      # preferred_background: 1e1e2e

      fish_color_normal cdd6f4
      fish_color_command 89b4fa
      fish_color_param f2cdcd
      fish_color_keyword f38ba8
      fish_color_quote a6e3a1
      fish_color_redirection f5c2e7
      fish_color_end fab387
      fish_color_comment 7f849c
      fish_color_error f38ba8
      fish_color_gray 6c7086
      fish_color_selection --background=313244
      fish_color_search_match --background=313244
      fish_color_option a6e3a1
      fish_color_operator f5c2e7
      fish_color_escape eba0ac
      fish_color_autosuggestion 6c7086
      fish_color_cancel f38ba8
      fish_color_cwd f9e2af
      fish_color_user 94e2d5
      fish_color_host 89b4fa
      fish_color_host_remote a6e3a1
      fish_color_status f38ba8
      fish_pager_color_progress 6c7086
      fish_pager_color_prefix f5c2e7
      fish_pager_color_completion cdd6f4
      fish_pager_color_description 6c7086
    '';

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting

        set sponge_allow_previously_successful true
        set sponge_purge_only_on_exit true

        fish_vi_key_bindings

        fish_config theme choose 'Catppuccin Mocha'

        function fish_user_key_bindings
          fish_vi_key_bindings

          bind --user -M visual -m default y "fish_clipboard_copy; commandline -f end-selection repaint-mode"
        end
      '';
      shellInit = '''';
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages;
        }
      ];
    };
  };
}
