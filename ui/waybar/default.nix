{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ui.waybar;
in
{

  imports = [
    ./style.nix
  ];

  options.ui = {
    waybar.enable = lib.mkEnableOption "Enable waybar";
    waybar.terminal = lib.mkOption {
      type = with lib.types; uniq str;
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.waybar
      pkgs.waybar_now_playing
      pkgs.wireplumber
      pkgs.playerctl
      pkgs.networkmanager
      pkgs.pavucontrol
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          margin-top = 2;
          gtk-layer-shell = true;
          fixed-center = true;

          modules-left = [
            "hyprland/workspaces"
            "custom/player"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "tray"
            "network"
            "wireplumber"
            "battery"
          ];
          "hyprland/workspaces" = {
            active-only = false;
            all-outputs = true;
            disable-scroll = true;
            format = "{name}";
            on-click = "activate";
            sort-by-number = true;
          };

          "custom/player" = {
            interval = 5;
            exec = "${pkgs.waybar_now_playing}/bin/waybar_now_playing";
            format = "Playing: {}";
            return-type = "json";
            max-length = 45;
            on-click = "${pkgs.waybar_now_playing}/bin/waybar_now_playing play-pause";
            on-click-right = "${pkgs.waybar_now_playing}/bin/waybar_now_playing next";
            on-click-middle = "${pkgs.waybar_now_playing}/bin/waybar_now_playing previous";
          };

          "clock" = {
            interval = 1;
            format = "{:%H:%M:%S  %a %d %B}";
          };

          "tray" = {
            icon-size = 16;
            spacing = 12;
          };

          "network" = {
            interval = 2;
            format-wifi = "    {essid}";
            format-ethernet = "󰈀 {essid}";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "! Disconnected";
            tooltip-format-wifi = "{signalStrength}% | ⬇ {bandwidthDownBits} ⬆ {bandwidthUpBits} | {ipaddr}/{cidr}";
            on-click = "${pkgs.kitty}/bin/kitty --name nmtui --title nmtui ${pkgs.networkmanager}/bin/nmtui";
          };

          "cpu" = {
            interval = 6;
            format = "󰾆   {usage}";
            tooltip = true;
          };

          "memory" = {
            interval = 6;
            format = "󰍛   {used}";
          };

          "wireplumber" = {
            format = "{icon} {volume}%";
            format-muted = "🔇 sssh..";
            scroll-step = 1;
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            format-icons = [
              " "
              " "
              " "
            ];
          };

          "battery" = {
            interval = 5;
            states = {
              good = 95;
              warning = 20;
              critical = 10;
            };
            format = "{icon}     {capacity}";
            format-charging = "⚡    {capacity}";
            format-plugged = "⚡    {capacity}";
            format-alt = "{time}   {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
        };
      };
    };
  };
}
