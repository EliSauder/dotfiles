{ config, pkgs, lib }: 
let
    cfg = config.prog.fish 
in {
    options.prog = {
        fish.enable = lib.mkEnableOption "Enable fish";
    };

    config = lib.mkIf cfg.enable {
        program.fish = {
            enable = true;
            plugins = [
                { name = "grc"; src = pkgs.fishPlugins.grc.src; }
                { name = "z"; src = pkgs.fishPlugins.z.src; }
                { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
                { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
                { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
                { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
            ];
        };
    };
}
