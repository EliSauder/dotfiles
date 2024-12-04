{config, pkgs, inputs, ...}: {
    programs.hypridle = {
        enable = true;
	settings = {
	    general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                after_sleep_cmd = "hyprctl dispatch dpms on";
                ignore_dbus_inhibit = false;
            };
            
            listener = [
	    	{
                    timeout = 600;
		    on-timeout = "hyprlock";
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
