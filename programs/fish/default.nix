{ config, pkgs, lib, ...}: 
let
    cfg = config.prog.fish;
in {
    options.prog = {
        fish.enable = lib.mkEnableOption "Enable fish";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.grc
            pkgs.fzf
            pkgs.fd
            pkgs.bat
        ];

        programs.fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting

                set sponge_allow_previously_successful true
            '';
            shellInit = ''
            '';
            plugins = [
                { name = "grc"; src = pkgs.fishPlugins.grc.src; }
                { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
                { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
                { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
                { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
                { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages; }
            ];
        };
    };
}
