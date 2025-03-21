{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.obsidian;
in {
    config.prog = {
        obsidian.enable = lib.mkEnableOption "Enable obsidian";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.obsidian
        ];
    };
}
