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
    waybar.terminal = {
      cmd = lib.mkOption {
        type = with lib.types; uniq str;
        default = "ghostty";
      };
      cmdArg = lib.mkOption {
        type = with lib.types; uniq str;
        default = "-e";
      };
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

    catppuccin.waybar = {
      enable = true;
      flavor = "mocha";
      mode = "createLink";
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          #margin-top = 2;
          height = 32;
          spacing = 0;
          gtk-layer-shell = true;
          fixed-center = true;

          modules-left = [
            "hyprland/workspaces"
            "tray"
            "custom/player"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "network"
            "bluetooth"
            "wireplumber"
            "backlight"
            "battery"
            "idle_inhibitor"
            "custom/reboot"
            "custom/power"
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

          "custom/reboot" = {
            format = "<span color='#FFD700'>  </span>";
            on-click = "systemctl reboot";
          };

          "custom/power" = {
            format = "<span color='#FF4040'>  </span>";
            on-click = "systemctl poweroff";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "<span color='#00AD0E'>󰅶 </span>";
              deactivated = "<span color='#037FFC'>󰾪 </span>";
            };
          };
          "clock" = {
            interval = 1;
            format = "{:%H:%M:%S  %a %d %B}";
          };

          "tray" = {
            icon-size = 17;
            spacing = 6;
          };

          "network" = {
            interval = 1;
            format-wifi = "<span color='#00FFFF'>  </span>  {essid} ";
            format-ethernet = "<span color='#7fff00'> 󰈀 </span>";
            format-linked = "<span color='#FFA500'> 󱘖 </span> {ifname} (No IP) ";
            format-disconnected = "<span color='#FF4040'>  </span> Disconnected ";
            tooltip-format-wifi = "{signalStrength}% | ⬇ {bandwidthDownBits} ⬆ {bandwidthUpBits} | {ipaddr}/{cidr}";
            on-click = "${cfg.terminal.cmd} ${cfg.terminal.cmdArg} ${pkgs.networkmanager}/bin/nmtui";
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
            format = "<span color='#00FF7F'>{icon}</span> {volume}% ";
            format-muted = "<span color='#FF4040'> 󰖁 </span>";
            #format = "{icon} {volume}%";
            #format-muted = "🔇 sssh..";
            scroll-step = 1;
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            format-icons = [
              "<span color='#808080'>  </span>"
              "<span color='#FFFF66'>  </span>"
              "<span color='#00FF7F'>  </span>"
            ];
          };

          "battery" = {
            interval = 1;
            states = {
              good = 95;
              warning = 20;
              critical = 10;
            };
            format = "<span color='#28CD41'> {icon} </span>{capacity}% ";
            format-charging = " 󱐋{capacity}%";
            format-alt = "{time}   {icon}";
            format-icons = [
              "󰂎"
              "󰁼"
              "󰁿"
              "󰂁"
              "󰁹"
            ];
            tooltip = true;
          };

          "bluetooth" = {
            format = "<span color='#00BFFF'>  </span>{status} ";
            format-connected = "<span color='#00BFFF'>  </span>{device_alias} ";
            format-connected-battery = "<span color='#00BFFF'>  </span>{device_alias} {device_battery_percentage}% ";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          };

          "backlight" = {
            device = "intel_backlight";
            format = "<span color='#FFD700'>{icon}</span> {percent}% ";
            tooltip = true;
            format-icons = [
              "<span color='#696969'> 󰃞 </span>"
              "<span color='#A9A9A9'> 󰃝 </span>"
              "<span color='#FFFF66'> 󰃟 </span>"
              "<span color='#FFD700'> 󰃠 </span>"
            ];
          };
        };
      };
    };
  };
}
