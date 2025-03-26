{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.obsidian;
in {
    options.prog = {
        obsidian.enable = lib.mkEnableOption "Enable obsidian";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.obsidian
        ];
    };
}
