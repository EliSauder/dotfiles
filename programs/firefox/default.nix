{config, pkgs, lib, ... }:
let
    cfg = config.prog.firefox;
in {
    config.prog = {
        firefox.enable = lib.mkEnableOption "Enable firefox";
    };

    options = lib.mkIf cfg.enable {
        programs.firefox = {
            enable = true;
            package = pkgs.firefox.override {
                nativeMessagingHosts = [
                pkgs.gnome-browser-connector
            ];
            };
            profiles = {
                personal = {
                id = 0;
                name = "personal";
                isDefault = true;
                settings = {
                    "browser.search.defaultenginename" = "DuckDuckGo";
          	        "browser.search.order.1" = "DuckDuckGo";
          	        "signon.rememberSignons" = false;
          	        "widget.use-xdg-desktop-portal.file-picker" = 1;
          	        "browser.aboutConfig.showWarning" = false;
          	        "browser.compactmode.show" = true;
          	        "browser.cache.disk.enable" = false;
                };
                search = {
                    force = true;
          	        default = "DuckDuckGo";
          	        order = [ "DuckDuckGo" "Brave" "Google" ];
                };
            };
            };
        };
    };
}
