{config, pkgs, ...}: {
    
    imports = [
        ./style.nix
    ];

    home.packages = [
        pkgs.waybar_now_playing
	pkgs.wireplumber
    ];

    programs.waybar = {
        enable = true;
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
                    format = "    {}";
	    	    return-type = "json";
	    	    max-length = 30;
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
	    	    format-ethernet = " {essid}";
	    	    format-linked = "{ifname} (No IP) ";
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

	        "pipewire" = {
	            format = "{volume}";
	    	    format-muted = "🔇 sssh..";
	    	    scroll-step = 1;
	    	    on-click = "${pkgs.helvum}";
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
}
