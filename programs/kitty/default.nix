{ config, lib, pkgs, ...}: 
let
    cfg = config.prog.kitty;
in{
    config.prog = {
        kitty.enable = lib.mkEnableOption "Enable kitty";
    };

    options = lib.mkIf cfg.enable {
        programs.kitty.enable = true;
    };
}
