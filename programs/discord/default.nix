{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.discord;
in {
    config.prog = {
        discord.enable = lib.mkEnableOption "Enable discord";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.discord
        ];
    };
}
