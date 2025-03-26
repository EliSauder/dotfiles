{ config, lib, pkgs, ...}: 
let
    cfg = config.prog.kitty;
in{
    options.prog = {
        kitty.enable = lib.mkEnableOption "Enable kitty";
    };

    config = lib.mkIf cfg.enable {
        programs.kitty.enable = true;
    };
}
