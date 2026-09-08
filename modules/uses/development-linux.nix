{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.development-linux;
in
{
  options.module = {
    development-linux.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      #pkgs.mqtt-explorer
      pkgs.inotify-info
    ];
  };
}
