{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.ui.rofi;
in
{
  options.ui = {
    rofi.enable = lib.mkEnableOption "Enable Wofi";
    rofi.commandPrefix = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      extraConfig = {
        drun-launch-prefix = "uwsm app -- ${cfg.commandPrefix}";
      };
      plugins = [
        pkgs.rofi-vpn
        pkgs.rofi-calc
        pkgs.rofi-emoji
        pkgs.rofi-systemd
        pkgs.rofi-obsidian
        pkgs.rofi-bluetooth
        pkgs.rofi-power-menu
      ];
    };
  };
}
