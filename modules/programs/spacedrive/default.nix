{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.spacedrive;
in {
    options.prog = {
        spacedrive.enable = lib.mkEnableOption "NEnable spacedrive";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.spacedrive
        ];
    };
}
