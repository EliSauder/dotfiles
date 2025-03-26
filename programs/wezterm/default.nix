{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.wezterm;
in {
    options.prog = {
        wezterm.enable = lib.mkEnableOption "Enable wezterm";
    };

    config = lib.mkIf cfg.enable {
        programs.wezterm = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            extraConfig = ''
                return {}
            '';
        };
    };
}
