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
    kitty.package = lib.mkPackageOption pkgs "kitty" { };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = cfg.package;

      shellIntegration = {
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };

      enableGitIntegration = false;

      settings = {
        scrollback_lines = 10000;
        cursor_trail = 1;
        wayland_enable_ime = true;
        clear_all_shortcuts = true;
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
