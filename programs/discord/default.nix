{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.discord;
in {
    options.prog = {
        discord.enable = lib.mkEnableOption "Enable discord";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.discord
        ];
    };
}
