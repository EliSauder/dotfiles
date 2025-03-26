{ config, lib, pkgs, ... }: 
let 
    cfg = config.prog.libreoffice;
in {
    options.prog = {
        libreoffice.enable = lib.mkEnableOption "Enable libreoffice";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.libreoffice-qt6
            pkgs.hunspell
            pkgs.hunspellDicts.en_US
        ];
    };

}
