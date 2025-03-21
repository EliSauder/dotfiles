{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.spacedrive;
in {
    config.prog = {
        spacedrive.enable = lib.mkEnableOption "NEnable spacedrive";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.spacedrive
        ];
    };
}
