{ config, lib, pkgs, ... }:
let
    cfg = config.prog.neovim;
in {
    options.prog = {
        neovim.enable = lib.mkEnableOption "Enable neovim";
    };

    config = lib.mkIf cfg.enable {

        programs.neovim = {
            enable = true;
        };
    };
}
