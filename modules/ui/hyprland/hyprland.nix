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
  systemXdgPortal =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  usedForWork = builtins.elem "work" specialArgs.uses;
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
      terminal.cmd = "${cfg.commandPrefix}${lib.getExe' cfg.terminal.package cfg.terminal.exeName}";
    };

    ui.rofi = {
      enable = true;
      commandPrefix = "${cfg.commandPrefix}";
    };
    ui.kanshi.enable = true;
    ui.mako.enable = true;
    ui.cliphist.enable = true;

    ui.hypridle = {
      enable = true;
    };

    catppuccin.hyprland.enable = true;

    home.packages = [
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.awww
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

    wayland.windowManager.hyprland =
      let
        setupScreenshotsFolder = "uwsm app -- ${pkgs.writeShellScriptBin "setupScreenshotsFolder.sh" ''

          test -d "$HOME/Pictures/Screenshots" || mkdir -p "$HOME/Pictures/Screenshots" 2>/dev/null

        ''}/bin/setupScreenshotsFolder.sh";

        launchTerminal = "uwsm app -- ${cfg.commandPrefix}${lib.getExe' cfg.terminal.package cfg.terminal.exeName}";
        launchBrowser = "uwsm app -- ${cfg.commandPrefix}${lib.getExe' cfg.browser.package cfg.browser.exeName}";
        launchFileManager = "uwsm app -- ${cfg.commandPrefix}${lib.getExe' cfg.fileManager.package cfg.fileManager.exeName}";
        launchGnomeTerminal = "uwsm app -- ${cfg.commandPrefix}gnome-terminal";
        launchMenu = "uwsm app -- ${cfg.commandPrefix}${lib.getExe' pkgs.rofi "rofi"} -show drun";

        captureScreenshot = "uwsm app -- ${pkgs.writeShellScriptBin "captureScreenshot.sh" ''
          #!/bin/bash 

          slrp="${cfg.commandPrefix}${lib.getExe' pkgs.slurp "slurp"}"
          grm="${cfg.commandPrefix}${lib.getExe' pkgs.grim "grim"}"
          svdir="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')"

          CAP="$(eval "$grm -g '$(eval "$slrp")' '$svdir'" 2>&1)"

          if [[ $? == 0 ]]; then
            notify-send ".. :: Slurp :: .." "partial screenshot captured"
          else
            notify-send ".. :: Slurp :: .." "failed partial screenshot" "" "$CAP"
          fi
        ''}/bin/captureScreenshot.sh";

        captureFullscreenScreenshot = "uwsm app -- ${pkgs.writeShellScriptBin "captureFsScreenshot.sh" ''
          #!/bin/bash
          slrp="${cfg.commandPrefix}${lib.getExe' pkgs.slurp "slurp"}"
          grm="${cfg.commandPrefix}${lib.getExe' pkgs.grim "grim"}"
          svdir="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')"

          CAP="$(eval "$grm '$svdir' 2>&1")"

          if [[ $? == 0 ]]; then
            notify-send ".. :: Grim :: .." "Screenshot captured successfully"
          else 
            notify-send ".. :: Grim :: .." "Failed to capture screenshot" "" "$CAP"
          fi
        ''}/bin/captureFsScreenshot.sh";

        restartFlakyUserSpace = "uwsm app -- ${pkgs.writeShellScriptBin "restartFlakyUs.sh" ''
          #!/bin/bash

          systemctl --user restart kanshi
          systemctl --user restar waybar
        ''}/bin/restartFlakyUs.sh";

        launchHyprPicker = "uwsm app -- ${cfg.commandPrefix}${pkgs.hyprpicker}/bin/hyprpicker -a -n";
        lockSession = "loginctl lock-session";
      in
      {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        systemd.enable = true;
        systemd.variables = [ "--all" ];
        systemd.enableXdgAutostart = true;
        xwayland.enable = true;
        configType = "lua";

        settings = {
          mod._var = "SUPER";

          on._args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("${setupScreenshotsFolder}")
                hl.exec_cmd("${launchTerminal}", { workspace = "1 silent" })
                hl.exec_cmd("${launchBrowser}", { workspace = "2 silent" })
                ${
                  if usedForWork then
                    ''
                      hl.exec_cmd(
                        "uwsm app -- ${cfg.commandPrefix}teams-for-linux", { workspace = "4 silent", fullscreen_state = "0 2"})
                      hl.exec_cmd(
                        "uwsm app -- ${launchBrowser} ${lib.concatStringsSep " " cfg.browser.launchWindowWithUrlArgs} https://outlook.office.com/mail/", { workspace = "4 silent", fullscreen_state = "0 2"})
                    ''
                  else
                    ""
                }
                ${lib.concatMapStringsSep " " (
                  cmd: "hl.exec_cmd(\"uwsm app -- ${cmd}\", { workspace = \"unset silent\"})"
                ) cfg.startupItems}
              end
            '')
          ];

          env = [
            {
              _args = [
                "CLIPBOARD_NOGUI"
                "1"
              ];
            }
            {
              _args = [
                "GDK_SCALE"
                "2"
              ];
            }
            {
              _args = [
                "QT_AUTO_SCREEN_SCALE_FACTOR"
                "1"
              ];
            }
            {
              _args = [
                "GDK_BACKEND"
                "wayland,x11,*"
              ];
            }
            {
              _args = [
                "QT_QPA_PLATFORM"
                "wayland;xcb"
              ];
            }
            {
              _args = [
                "XDG_CURRENT_DESKTOP"
                "Hyprland"
              ];
            }
            {
              _args = [
                "XDG_SESSION_TYPE"
                "wayland"
              ];
            }
            {
              _args = [
                "XDG_SESSION_DESKTOP"
                "Hyprland"
              ];
            }
            {
              _args = [
                "QT_QPA_PLATFORMTHEME"
                "qt5ct"
              ];
            }
            {
              _args = [
                "XCURSOR_SIZE"
                "24"
              ];
            }
            {
              _args = [
                "XCURSOR_THEME"
                "BreezeX-RosePine"
              ];
            }
            {
              _args = [
                "HYPRCURSOR_SIZE"
                "24"
              ];
            }
            {
              _args = [
                "HYPRCURSOR_THEME"
                "rose-pine-hyprcursor"
              ];
            }
            {
              _args = [
                "WLR_NO_HARDWARE_CURSORS"
                "1"
              ];
            }
          ]
          ++ (lib.optionals cfg.useNvidia [
            {
              _args = [
                "LIBVA_DRIVER_NAME"
                "nvidia"
              ];
            }
            {
              _args = [
                "__GLX_VENDOR_LIBRARY_NAME"
                "nvidia"
              ];
            }
            {
              _args = [
                "ELECTRON_OZONE_PLATFORM_HINT"
                "auto"
              ];
            }
            {
              _args = [
                "NVD_BACKEND"
                "direct"
              ];
            }
          ]);

          config = {
            general = {
              gaps_in = 0;
              gaps_out = 2;
              border_size = 2;
              #"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
              "col.active_border" = "rgba(33ccffee)";
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

            };
            dwindle = {
              #pseudotile = true;
              preserve_split = true;
              smart_split = false;
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
            xwayland.force_zero_scaling = true;
          };

          curve = [
            {
              _args = [
                "myBezier"
                (lib.mkLuaInline "{type = \"bezier\", points = {{0.05, 0.9}, {0.1, 1.05}}}")
              ];
            }
          ];
          animation = [
            {
              leaf = "windows";
              enabled = true;
              speed = 7;
              bezier = "myBezier";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 7;
              bezier = "myBezier";
              style = "popin 80%";
            }
            {
              leaf = "border";
              enabled = true;
              speed = 10;
              bezier = "default";
            }
            {
              leaf = "borderangle";
              enabled = true;
              speed = 8;
              bezier = "default";
            }
            {
              leaf = "fade";
              enabled = true;
              speed = 7;
              bezier = "default";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 6;
              bezier = "default";
            }
          ];

          layer_rule = [
            {
              match.namespace = "waybar";
              ignore_alpha = true;
              blur = true;
            }
            {
              match.namespace = "gtk-layer-shell";
              ignore_alpha = true;
              blur = true;
            }
            {
              match.namespace = "launcher";
              ignore_alpha = true;
              blur = true;
            }
            {
              match.namespace = "wofi";
              ignore_alpha = true;
              blur = true;
              no_anim = true;
            }
            {
              match.namespace = "rofi";
              ignore_alpha = true;
              blur = true;
              no_anim = true;
            }
            {
              match.namespace = "notifications";
              ignore_alpha = true;
              blur = true;
            }
            {
              match.namespace = "anyrun";
              ignore_alpha = true;
              blur = true;
            }
            {
              match.namespace = "selection";
              no_anim = true;
            }
            {
              match.namespace = "hyprpicker";
              no_anim = true;
            }
          ];

          window_rule = [
            {
              float = true;
              center = true;
              match.title = "Library";
            }
            {
              float = true;
              center = true;
              match.title = "mpv";
              size = "1299 701";
            }
            {
              float = true;
              match.title = "nemo";
            }
            {
              float = true;
              match.title = "pavucontrol";
            }
            {
              no_anim = true;
              match.title = "REAPER";
            }
            {
              float = true;
              pin = true;
              center = true;
              opaque = true;
              opacity = "0.3";
              dim_around = true;
              stay_focused = true;
              match.class = "wofi";
            }
            {
              float = true;
              pin = true;
              center = true;
              opaque = true;
              opacity = 0.3;
              dim_around = true;
              stay_focused = true;
              match.class = "rofi";
            }
            {
              suppress_event = "maximize";
              match.class = ".*";
            }
            {
              opacity = "0.0 override";
              no_anim = true;
              no_initial_focus = true;
              max_size = "1 1";
              no_blur = true;
              match.class = "xwaylandvideobridge";
            }
            {
              workspace = "5 silent";
              match.class = "steam";
            }
            {
              size = "25% 100%";
              match.class = "steam";
              match.title = "Friends List";
            }
            {
              workspace = "5 silent";
              match.class = "XIVLauncher.Core";
            }
            {
              workspace = "4 silent";
              match.class = "discord";
            }
            {
              workspace = "9 silent";
              match.class = "com.obsproject.Studio";
            }
            {
              workspace = "2";
              match.class = "firefox";
            }
            {
              workspace = "2";
              match.class = ".*qutebrowser";
            }
            {
              workspace = "4 silent";
              match.class = "teams-for-linux";
            }
            {
              workspace = "4 silent";
              match.title = "(.*)(Outlook)(.*)|(.*)(outlook.office.com)(.*)";
              fullscreen_state = "0 2";
            }
            {
              workspace = "4 silent";
              match.title = "(.*)(Microsoft Teams)(.*)|(.*)(teams.microsoft.com)(.*)";
              fullscreen_state = "0 2";
            }
            {
              workspace = "8 silent";
              match.class = "factorio";
            }
            {
              workspace = "8 silent";
              match.class = "steam_app_.*";
              fullscreen = true;
            }
            {
              workspace = "10 silent";
              center = true;
              match.title = "Vivado.*";
            }
            {
              workspace = "3";
              match.class = "REAPER";
              match.initial_title = "REAPER v[0-9]*.*";
            }
            {
              workspace = "6";
              match.class = "REAPER";
              match.title = "FX:.*";
            }
            {
              no_focus = true;
              match.class = "REAPER";
            }
            {
              center = true;
              match.class = "REAPER";
              match.title = "(?!menu).*";
            }
          ];
          bind = [
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + Q\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${launchTerminal}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + C\"")
                (lib.generators.mkLuaInline "hl.dsp.window.close()")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + F\"")
                (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({action = \"toggle\", mode = \"maximized\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + F\"")
                (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({action = \"toggle\", mode = \"fullscreen\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + B\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${launchBrowser}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + CTRL + M\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm stop\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + O\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${launchMenu} -show-icons\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + V\"")
                (lib.generators.mkLuaInline "hl.dsp.window.float({action = \"toggle\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + S\"")
                (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + P\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${captureScreenshot}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + P\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${captureFullscreenScreenshot}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + E\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${launchFileManager}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + K\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${restartFlakyUserSpace}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + left\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"l\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + h\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"l\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + right\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"r\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + l\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"r\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + up\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"u\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + k\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"u\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + down\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"d\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + j\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({direction=\"d\"})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_End\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"1\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Down\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"2\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Page_Down\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"3\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Left\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"4\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Begin\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"5\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Right\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"6\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Home\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"7\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Up\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"8\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Page_Up\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"9\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + KP_Insert\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"10\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 1\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"1\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 2\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"2\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 3\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"3\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 4\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"4\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 5\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"5\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 6\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"6\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 7\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"7\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 8\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"8\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 9\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"9\", on_current_monitor=true})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + 0\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace=\"10\", on_current_monitor=true})")
              ];
            }

            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_End\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"1\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Down\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"2\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Page_Down\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"3\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Left\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"4\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Begin\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"5\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Right\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"6\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Home\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"7\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Up\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"8\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Page_Up\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"9\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + KP_Insert\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"10\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 1\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"1\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 2\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"2\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 3\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"3\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 4\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"4\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 5\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"5\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 6\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"6\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 7\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"7\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 8\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"8\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 9\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"9\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + 0\"")
                (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=\"10\", follow=false})")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + X\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${launchHyprPicker}\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + L\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${lockSession}\")")
              ];
            }
            {
              _args = [
                "XF86MonBrightnessDown"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl s 5%-\")")
              ];
            }
            {
              _args = [
                "XF86MonBrightnessUp"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl s +5%\")")
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-\")")
              ];
            }
            {
              _args = [
                "XF86AudioRaiseVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+\")")
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + mouse:272\"")
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                (lib.generators.mkLuaInline "{ mouse = true }")
              ];
            }
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + mouse:273\"")
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                (lib.generators.mkLuaInline "{ mouse = true }")
              ];
            }
          ]
          ++ (lib.optionals isUbuntu [
            {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + SHIFT + Q\"")
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${launchGnomeTerminal}\")")
              ];
            }
          ]);
          monitor = {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "auto";
          };
        };

      };
  };
}
