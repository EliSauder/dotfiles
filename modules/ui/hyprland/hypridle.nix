{
  config,
  lib,
  pkgs,
  inputs,
  specialArgs,
  ...
}:
let
  hyprctlbin = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";
  cfg = config.ui.hypridle;
  isUbuntu = specialArgs.distro == "ubuntu";

  startlockscript = "${pkgs.writeShellScriptBin "statefullock.sh" ''
    #!/bin/bash

    if ! which hyprctl hyprlock jq touch pidof; then
        exit 1
    elif pidof hyprlock; then
        exit 0
    fi

    touch ~/.hyprlock.lock
    hyprctl activeworkspace -j | jq '.id' > ~/.hyprlock.lock
    hyprctl dispatch workspace $(( $(hyprctl workspaces -j | jq '[.[].id] | max') + 1 ));
    sleep 0.05
    ${if isUbuntu then "/usr/bin/hyprlock" else "${pkgs.hyprlock}/bin/hyprlock"}

    if [ "$(cat ~/.hyprlock.lock | grep -c "^[0-9]*$")" -eq 1 ]; then
        hyprctl dispatch workspace "$(cat ~/.hyprlock.lock | xargs)"
    fi
    rm ~/.hyprlock.lock
  ''}/bin/statefullock.sh";
in
{
  imports = [
    ./hyprlock.nix
  ];

  options.ui = {
    hypridle.enable = lib.mkEnableOption "Enable hypridle";
  };

  config = lib.mkIf cfg.enable {

    ui.hyprlock = {
      enable = true;
    };

    home.packages = [
      pkgs.hypridle
      pkgs.jq
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = startlockscript;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${hyprctlbin} dispatch dpms on";
          ignore_dbus_inhibit = false;
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
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
