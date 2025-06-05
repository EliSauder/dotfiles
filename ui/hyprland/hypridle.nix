{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hyprctlbin = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";
  cfg = config.ui.hypridle;
in
{
  imports = [
    ./hyprlock.nix
  ];

  options.ui = {
    hypridle.enable = lib.mkEnableOption "Enable hypridle";
    hypridle.lockScript = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    ui.hyprlock = {
      enable = true;
    };

    home.packages = [
      pkgs.hypridle
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${cfg.lockScript}";
          after_sleep_cmd = "${hyprctlbin} dispatch dpms on";
          ignore_dbus_inhibit = false;
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "${cfg.lockScript}";
            #on-timeout = "hyprctl dispatch workspace 11 ; pidof hyprlock || hyprlock";
          }
          {
            timeout = 900;
            on-timeout = "${hyprctlbin} dispatch dpms off";
            on-resume = "${hyprctlbin} dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
