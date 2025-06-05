{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.kitty;
in
{
  options.prog = {
    kitty.enable = lib.mkEnableOption "Enable kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      shellIntegration = {
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };

      enableGitIntegration = true;

      settings = {
        scrollback_lines = 10000;
        cursor_trail = 1;
        wayland_enable_ime = true;
        clear_all_shortcuts = true;
        #shell = "${pkgs.fish}/bin/fish -i -l -c ${pkgs.sesh}/bin/sesh connect default";
        shell = "${pkgs.fish}/bin/fish -i -l -c 'exec ${pkgs.sesh}/bin/sesh connect default'";
      };

      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_frome_clipboard";
      };

      #extraConfig = ''
      #  startup_session
      #'';

      font = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
    };
  };
}
