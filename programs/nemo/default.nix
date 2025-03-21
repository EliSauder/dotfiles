{ config, lib, pkgs, ... }: 
let 
    cfg = config.prog.nemo;
in {
    config.prog = {
        nemo.enable = lib.mkEnableOption "Enable libreoffice";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.nemo-with-extensions
            pkgs.nemo-python
            pkgs.nemo-emblems
        ];
    };

}
