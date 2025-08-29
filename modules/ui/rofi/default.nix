{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.ui.rofi;
in
{
  options.ui = {
    rofi.enable = lib.mkEnableOption "Enable Wofi";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = [
        pkgs.rofi-vpn
        pkgs.rofi-calc
        pkgs.rofi-emoji-wayland
        pkgs.rofi-systemd
        pkgs.rofi-obsidian
        pkgs.rofi-bluetooth
        pkgs.rofi-power-menu
      ];
    };
  };
}
