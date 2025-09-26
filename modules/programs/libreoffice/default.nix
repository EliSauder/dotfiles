{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.libreoffice;
in
{
  options.prog = {
    libreoffice.enable = lib.mkEnableOption "Enable libreoffice";
    libreoffice.commandPrefix = lib.mkOption {
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.hunspell
      pkgs.hunspellDicts.en_US
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.libreoffice
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      pkgs.libreoffice-bin
    ];
  };
}
