{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.librewolf;
in
{
  options.prog = {
    librewolf.enable = lib.mkEnableOption "Enable librewolf";
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
        nativeMessagingHosts = [
          pkgs.gnome-browser-connector
        ];
      };
    };
  };
}
