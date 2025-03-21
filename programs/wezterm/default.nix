{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.wezterm;
in {
    config.prog = {
        wezterm.enable = lib.mkEnableOption "Enable wezterm";
    };

    options = {
        programs.wezterm = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            extraConfig = ''
                return {}
            ''
        };
    };
}
