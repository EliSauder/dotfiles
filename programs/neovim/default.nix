{ config, lib, pkgs, ... }:
let
    cfg = config.prog.neovim;
in {
    config.prog = {
        neovim.enable = lib.mkEnableOption "Enable neovim";
    };

    options = lib.mkIf cfg.enable {

        programs.neovim = {
            enable = true;
        };
    };
}
