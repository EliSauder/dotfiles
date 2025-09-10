{
  config,
  lib,
  pkgs,
  inputs,
  specialArgs,
  ...
}:
let
  cfg = config.ui.hyprland;
  isUbuntu = specialArgs.distro == "ubuntu";
  systemXdgPortal = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
in
{
  imports = [
    ../waybar
    ../rofi
    ../mako
    ../cliphist
    ./hypridle.nix
    ../kanshi
  ];

  options.ui = {
    hyprland.enable = lib.mkEnableOption "Enable wayland";
    hyprland.commandPrefix = lib.mkOption {
      default = "";
    };
    hyprland.terminal = {
      package = lib.mkPackageOption pkgs "kitty" {
        default = "kitty";
      };
      exeName = lib.mkOption {
        type = with lib.types; uniq str;
        default = "";
      };
    };
    hyprland.browser = {
      package = lib.mkPackageOption pkgs "firefox" {
        default = "firefox";
      };
      exeName = lib.mkOption {
        type = with lib.types; uniq str;
        default = "";
      };
      launchWindowWithUrlArgs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
      };
    };
    hyprland.fileManager = {
      package = lib.mkPackageOption pkgs.kdePackages "dolphin" {
        default = "dolphin";
      };
      exeName = lib.mkOption {
        type = with lib.types; uniq str;
        default = "";
      };
    };
    hyprland.startupItems = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
    hyprland.keybinds = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
    hyprland.useNvidia = lib.mkOption {
      type = with lib.types; bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    ui.waybar = {
      enable = true;
      terminal = cfg.terminal;
    };

    ui.rofi.enable = true;
    ui.kanshi.enable = true;
    ui.mako.enable = true;
    ui.cliphist.enable = true;

    ui.hypridle = {
      enable = true;
    };

    catppuccin.hyprland.enable = true;

    home.packages = [
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.swww
      pkgs.mako
      pkgs.hyprpicker
      pkgs.grim
      pkgs.slurp
      pkgs.satty
      pkgs.jq
      pkgs.sysvtools
      pkgs.coreutils-full
      pkgs.inotify-tools
    ];

    xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = ''
      [preferred]
      default = hyprland;gtk
      org.freedesktop.impl.portal.FileChooser = kde
    '';

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [
          "hyprland"
          "gtk"
          "kde"
        ]
        ++ lib.optionals isUbuntu [
          "gnome"
        ];
      };
      extraPortals = [
        systemXdgPortal
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.xdg-desktop-portal-kde
      ]
      ++ lib.optionals isUbuntu [
        pkgs.xdg-desktop-portal-gnome
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
      systemd.enableXdgAutostart = true;
      xwayland.enable = true;

      settings = {
        "$mod" = "SUPER";
        "$terminal" = "${cfg.commandPrefix}${lib.getExe' cfg.terminal.package cfg.terminal.exeName}";
        "$fileManager" =
          "${cfg.commandPrefix}${lib.getExe' cfg.fileManager.package cfg.fileManager.exeName}";
        "$menu" = "${cfg.commandPrefix}${pkgs.rofi-wayland}/bin/rofi -show drun";
        "$browser" = "${cfg.commandPrefix}${lib.getExe' cfg.browser.package cfg.browser.exeName}";
        exec-once = [
          "uwsm app -- test -d \"$HOME/Pictures/Screenshots\" || mkdir -p \"$HOME/Pictures/Screenshots\" 2>/dev/null"
          "[workspace 1 silent] uwsm app -- $terminal"
          "[workspace 2 silent] uwsm app -- $browser"
          "[workspace 4 silent; fullscreenstate 0 2] uwsm app -- sleep 2 ; $browser ${lib.concatStringsSep " " cfg.browser.launchWindowWithUrlArgs} https://teams.microsoft.com/v2/"
          "[workspace 4 silent; fullscreenstate 0 2] uwsm app -- sleep 2 ; $browser ${lib.concatStringsSep " " cfg.browser.launchWindowWithUrlArgs} https://outlook.office.com/mail/"
        ]
        ++ cfg.startupItems;
        env = [
          "CLIPBOARD_NOGUI,1"
          "GDK_SCALE,2"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          #"QT_QPA_PLATFORMTHEME,qt5ct"
          #"XCURSOR_SIZE,24"
          #"XCURSOR_THEME,BreezeX-RosePine"
          #"HYPRCURSOR_SIZE,24"
          #"HYPRCURSOR_THEME,rose-pine-hyprcursor"
          #"WLR_NO_HARDWARE_CURSORS,1"
        ]
        ++ (lib.optionals cfg.useNvidia [
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "NVD_BACKEND,direct"
        ]);
        general = {
          gaps_in = 0;
          gaps_out = 2;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };
        decoration = {
          active_opacity = 1.0;
          inactive_opacity = 0.95;
          blur = {
            enabled = true;
            size = 20;
            passes = 1;
            vibrancy = 0.1696;
          };
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
        };
        animations = {
          enabled = false;

          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
          ];

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
          smart_split = "no";
        };
        master = {
          new_status = "master";
        };
        binds = {
          movefocus_cycles_fullscreen = true;
          workspace_center_on = true;
          workspace_back_and_forth = false;
        };
        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 0;
          sensitivity = 0;
          touchpad.natural_scroll = false;
          numlock_by_default = true;
          accel_profile = "flat";
        };
        gestures = {
          workspace_swipe = false;
        };
        xwayland.force_zero_scaling = true;
        layerrule = [
          "blur, waybar"
          "blur, gtk-layer-shell"
          "blur, launcher"
          "blur, wofi"
          "blur, notifications"
          "blur, anyrun"
          "ignorezero, waybar"
          "ignorezero, gtk-layer-shell"
          "ignorezero, wofi"
          "ignorezero, notifications"
          "ignorezero, anyrun"
          "noanim, wofi"
          "noanim, selection"
          "noanim, hyprpicker"
        ];
        windowrule = [
          "float, title:Library"
          "center, title:Library"
          "float, title:mpv"
          "center, title:mpv"
          "size 1299 701, title:mpv"
          "float, title:nemo"
          "float, title:pavucontrol"
          "noanim, title:^(REAPER)$"

          "float, class:(^wofi$)"
          "center, class:(^wofi$)"
          "pin, class:(^wofi$)"
          "opaque, class:(^wofi$)"
          "opacity 0.3, class:(^wofi$)"
          "dimaround, class:(^wofi$)"
          "stayfocused, class:(^wofi$)"
          "noanim, class:(^wofi$)"
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$wayland:1,floating:1,fullscreen:0,pinned:0"
          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"

          "workspace 5 silent, class:^(steam)$"
          "workspace 5 silent, class:^(steam)$,title:^(notification)(.*)$"
          "size 25% 100%, class:^(steam)$,title:^(Friends List)$"
          "workspace 5 silent, class:^(XIVLauncher.Core)$"
          "workspace 4 silent, class:^(discord)$"
          "workspace 9 silent, class:^(com.obsproject.Studio)$"

          "workspace 2, class:firefox"
          "workspace 2, class:.*qutebrowser"

          "workspace 4 silent, title:(.*)(Outlook)(.*)"
          "workspace 4 silent, title:(.*)(outlook.office.com)(.*)"
          "fullscreenstate 0 2, title:(.*)(Outlook)(.*)"
          "fullscreenstate 0 2, title:(.*)(outlook.office.com)(.*)"
          "workspace 4 silent, title:(.*)(Microsoft Teams)(.*)"
          "workspace 4 silent, title:(.*)(teams.microsoft.com)(.*)"
          "fullscreenstate 0 2, title:(.*)(Microsoft Teams)(.*)"
          "fullscreenstate 0 2, title:(.*)(teams.micorosft.com)(.*)"

          "workspace 8 silent, class:^(factorio)$"
          "workspace 8 silent, class:^(steam_app_)(.*)$"
          "fullscreen, class:^(steam_app_)(.*)$"

          "workspace 10, title:^(Vivado)(.*)$"
          "center, title:^(Vivado)(.*)$"
          "tile, title:^(Vivado)(.*)$"

          "workspace 3, class:REAPER, initialTitle:^(REAPER v[0-9]*)(.*)$"
          "workspace 6, class:REAPER, title:^FX:(.*)$"
          "tile, initialTitle:^(REAPER v[0-9]*)(.*)$"
          "tile, title:^FX:(.*)$"
          "nofocus,class:REAPER,title:^$"
          #"center,class:REAPER,title:^(?!menu)(.*)$"
        ];
        bind = [
          "$mod, Q, exec, uwsm app -- $terminal"
          "$mod SHIFT, Q, exec, uwsm app -- ${cfg.commandPrefix}gnome-terminal"
          "$mod, C, killactive,"
          "$mod, F, fullscreen,"
          "$mod, B, exec, uwsm app -- $browser"
          "$mod SHIFT CTRL, M, exec, uwsm stop"
          "$mod, V, togglefloating,"
          "$mod, O, exec, uwsm app -- $menu -show-icons"
          #"$mod, R, exec, rofi -show drun -show-icons -log ~/rofi.log"
          "$mod, J, togglesplit,"
          #"$mod, D, exec, ${pkgs.discord}/bin/discord"
          "$mod, P, exec, uwsm app -- ${cfg.commandPrefix}${pkgs.grim}/bin/grim -g \"$(${cfg.commandPrefix}${pkgs.slurp}/bin/slurp)\" \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..:: Slurp ::..\" \"partial screenshot captured\""
          "$mod SHIFT, P, exec, uwsm app -- ${cfg.commandPrefix}${pkgs.grim}/bin/grim \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..::  Grim  ::..\" \"screenshot captured successfully\""
          "$mod, E, exec, uwsm app -- $fileManager"

          "$mod, left, movefocus, l"
          "$mod, h, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, l, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, k, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, j, movefocus, d"

          "$mod, KP_End, workspace, 1"
          "$mod, KP_Down, workspace, 2"
          "$mod, KP_Page_Down, workspace, 3"
          "$mod, KP_Left, workspace, 4"
          "$mod, KP_Begin, workspace, 5"
          "$mod, KP_Right, workspace, 6"
          "$mod, KP_Home, workspace, 7"
          "$mod, KP_Up, workspace, 8"
          "$mod, KP_Page_Up, workspace, 9"
          "$mod, KP_Insert, workspace, 10"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          "$mod SHIFT, KP_End, movetoworkspace, 1"
          "$mod SHIFT, KP_Down, movetoworkspace, 2"
          "$mod SHIFT, KP_Page_Down, movetoworkspace, 3"
          "$mod SHIFT, KP_Left, movetoworkspace, 4"
          "$mod SHIFT, KP_Begin, movetoworkspace, 5"
          "$mod SHIFT, KP_Right, movetoworkspace, 6"
          "$mod SHIFT, KP_Home, movetoworkspace, 7"
          "$mod SHIFT, KP_Up, movetoworkspace, 8"
          "$mod SHIFT, KP_Page_Up, movetoworkspace, 9"
          "$mod SHIFT, KP_Insert, movetoworkspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          "$mod SHIFT, X, exec, uwsm app -- ${cfg.commandPrefix}${pkgs.hyprpicker}/bin/hyprpicker -a -n"
          "$mod SHIFT, L, exec, loginctl lock-session"
          ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"
          ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%"
          ",XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ]
        ++ cfg.keybinds;
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        monitor = [
          ", preferred, auto, 1"
          #"desc:Microstep MAG321UX OLED, 3840x2160@239.99, auto, 1.5"
          #"desc:LG Display 0x06B3, 1920x1200@59.95, auto, 1"
          #"desc:Dell Inc. DELL U2410 C592M21B2APL, 1920x1200@59.95, auto, 1"
        ];
      };
    };
  };
}
