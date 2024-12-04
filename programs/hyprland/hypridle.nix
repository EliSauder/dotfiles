{config, pkgs, inputs, ...}: {
    services.hypridle = {
        enable = true;
	settings = {
	    general = {
	        lock_cmd = "~/.scripts/statefullock.sh";
                after_sleep_cmd = "hyprctl dispatch dpms on";
                ignore_dbus_inhibit = false;
            };
            
            listener = [
	    	{
                    timeout = 600;
		    on-timeout = "~/.scripts/statefullock.sh";
                    #on-timeout = "hyprctl dispatch workspace 11 ; pidof hyprlock || hyprlock";
		}
		{
                    timeout = 900;
		    on-timeout = "hyprctl dispatch dpms off";
		    on-resume = "hyprctl dispatch dpms on";
		}
		{
		    timeout = 1800;
		    on-timeout = "systemctl suspend";
		}
            ];
	};
    };
}
