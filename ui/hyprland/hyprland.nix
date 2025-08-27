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
  nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
  systemXdgPortal = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  #systemXdgPortal =
  #  if isUbuntu then
  #    pkgs.xdg-desktop-portal-gnome
  #  else
  #    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
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
    hyprctl dispatch exec ${if isUbuntu then "/usr/bin/hyprlock" else "${pkgs.hyprlock}/bin/hyprlock"}
    sleep 0.1

    if [ "$(cat ~/.hyprlock.lock | grep -c "^[0-9]*$")" -eq 1 ]; then
        hyprctl dispatch workspace "$(cat ~/.hyprlock.lock | xargs)"
    fi
    rm ~/.hyprlock.lock
    rm ~/.hyprlock-status.lock
  ''}/bin/statefullock.sh";
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
    hyprland.terminal = lib.mkOption {
      type = with lib.types; uniq str;
      default = [ ];
    };
    hyprland.browser = lib.mkOption {
      type = with lib.types; uniq str;
      default = [ ];
    };
    hyprland.fileManager = lib.mkOption {
      type = with lib.types; uniq str;
      default = [ ];
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
      lockScript = "${startlockscript}";
    };

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
        #"$terminal" = "${nixGLStart}${pkgs.kitty}/bin/kitty";
        "$terminal" = "${nixGLStart}${cfg.terminal}";
        "$fileManager" = "${nixGLStart}${cfg.fileManager}";
        #"$menu" = "${nixGLStart}wofi --show drun";
        "$menu" = "${nixGLStart}${pkgs.rofi-wayland}/bin/rofi -show drun";
        "$browser" = "${nixGLStart}${cfg.browser}";
        exec-once = [
          "uwsm app -- test -d \"$HOME/Pictures/Screenshots\" || mkdir -p \"$HOME/Pictures/Screenshots\" 2>/dev/null"
          #"uwsm app -- [workspace 1 silent] $terminal"
          #"uwsm app -- [workspace 2 silent] $browser"
        ]
        ++ cfg.startupItems;
        env = [
          #"WLR_NO_HARDWARE_CURSORS,1"
          "CLIPBOARD_NOGUI,1"
          #"XCURSOR_SIZE,24"
          #"XCURSOR_THEME,BreezeX-RosePine"
          #"HYPRCURSOR_SIZE,24"
          #"HYPRCURSOR_THEME,rose-pine-hyprcursor"
          "GDK_SCALE,2"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt5ct"
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
        #// lib.mkIf (isUbuntu) {
        #  drop_shadow = true;
        #  shadow_range = 4;
        #  "col.shadow" = "rgba(1a1a1aee)";
        #  shadow_render_power = 3;
        #};
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
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false;
          numlock_by_default = true;
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
        ];
        windowrulev2 = [
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

          "workspace 2, class:^(firefox)$"
          "workspace 5 silent, class:^(steam)$"
          "workspace 5 silent, class:^(steam)$,title:^(notification)(.*)$"
          "size 25% 100%, class:^(steam)$,title:^(Friends List)$"
          "workspace 5 silent, class:^(XIVLauncher.Core)$"
          "workspace 4 silent, class:^(discord)$"
          "workspace 9 silent, class:^(com.obsproject.Studio)$"

          "workspace 8 silent, class:^(factorio)$"
          "workspace 8 silent, class:^(steam_app_431960)$"
          "fullscreen, class:^(steam_app_431960)$"

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
          "$mod SHIFT, Q, exec, uwsm app -- ${nixGLStart}gnome-terminal"
          "$mod, C, killactive,"
          "$mod, F, fullscreen,"
          "$mod, B, exec, uwsm app -- $browser"
          "$mod SHIFT CTRL, M, exec, uwsm stop"
          "$mod, V, togglefloating,"
          "$mod, H, exec, uwsm app -- $menu -show-icons"
          #"$mod, R, exec, rofi -show drun -show-icons -log ~/rofi.log"
          "$mod, J, togglesplit,"
          #"$mod, D, exec, ${pkgs.discord}/bin/discord"
          "$mod, P, exec, uwsm app -- ${nixGLStart}${pkgs.grim}/bin/grim -g \"$(${nixGLStart}${pkgs.slurp}/bin/slurp)\" \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..:: Slurp ::..\" \"partial screenshot captured\""
          "$mod SHIFT, P, exec, uwsm app -- ${nixGLStart}${pkgs.grim}/bin/grim \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..::  Grim  ::..\" \"screenshot captured successfully\""
          "$mod, E, exec, uwsm app -- ${nixGLStart}${cfg.fileManager}"

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

          "$mod SHIFT, X, exec, uwsm app -- ${nixGLStart}${pkgs.hyprpicker}/bin/hyprpicker -a -n"
          "$mod, L, exec, ${startlockscript}"
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
