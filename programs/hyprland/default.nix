{config, pkgs, inputs, ...}: {
  imports = [
     ./hypridle.nix
     ./hyprlock.nix
  ];

  wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
      xwayland.enable = true;

      settings = {
        "$mod" = "SUPER";
	"$terminal" = "kitty";
	"$fileManager" = "dolphin";
	"$menu" = "wofi --show drun";
	"$browser" = "firefox";
	exec-once = [
	    "waybar"
	    "mako"
	    "hypridle"
	    "cliphist --type text --watch cliphist store"
	    "cliphist --type image --watch cliphist store"
	    "test -d \"$HOME/Pictures/Screenshots\" || mkdir -p \"$HOME/Pictures/Screenshots\" 2>/dev/null"
	    "kitty"
	    "firefox"
	    "steam"
	    "discord"
	    "obs"
	];
	env = [
	    "XCURSOR_SIZE,24"
	    "XCURSOR_THEME,BreezeX-RosePine"
	    "HYPRCURSOR_SIZE,24"
	    "HYPRCURSOR_THEME,rose-pine-hyprcursor"
	    "GDK_SCALE,2"
	    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
	    "GDK_BACKEND,wayland,x11,*"
	    "QT_QPA_PLATFORM,wayland;xcb"
	];
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

	    shadow = {
	        enabled = true;
		range = 4;
		render_power = 3;
		color = "rgba(1a1a1aee)";
	    };

	    active_opacity = 1.0;
	    inactive_opacity = 0.95;
	    blur = {
	        enabled = true;
		size = 20;
		passes = 1;
		vibrancy = 0.1696;
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
	    "float, mpv"
	    "center, mpv"
	    "size 1299 701, mpv"
	    "float, nemo"
	    "float, pavucontrol"
	    "noanim,^(REAPER)$"
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
	    "center,class:REAPER,title:^(?!menu)(.*)$"
	];
        bind = [
          "$mod, Q, exec, $terminal"
          "$mod, C, killactive,"
	  "$mod, F, fullscreen,"
          "$mod, B, exec, $browser"
          "$mod, M, exit,"
          "$mod, V, togglefloating,"
	  "$mod, R, exec, pkill $menu ; $menu"
	  "$mod, J, togglesplit,"
	  "$mod, D, exec, ${pkgs.discord}/bin/discord"
	  "$mod, P, exec, pkill slurp || grim -g \"$(slurp)\" \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..:: Slurp ::..\" \"partial screenshot captured\""
	  "$mod SHIFT, P, exec, grim \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..::  Grim  ::..\" \"screenshot captured successfully\""
	  "$mod SHIFT, P, exec, grim \"$HOME/Pictures/Screenshots/$(date +'%Y-%m-%dT%H.%M.%S%z.png')\" && notify-send \"..::  Grim  ::..\" \"screenshot captured successfully\""
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
	  "$mod SHIFT, X, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a -n"
        ];
	bindm = [
	    "$mod, mouse:272, movewindow"
	    "$mod, mouse:273, resizewindow"
	];
	monitor = [
	    ", preferred, auto, 1"
	    "desc:Microstep MAG321UX OLED, 3840x2160@239.99, auto, 1.5"
	];
      };
    };
}
