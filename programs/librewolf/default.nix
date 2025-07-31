{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.librewolf;
  isLinux = pkgs.stdenv.isLinux;
in
{
  options.prog = {
    librewolf.enable = lib.mkEnableOption "Enable librewolf";
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      package = if isLinux then 
      	pkgs.librewolf.override {
        nativeMessagingHosts = [
          pkgs.gnome-browser-connector
        ];
      } else pkgs.librewolf;
    };
  };
}
