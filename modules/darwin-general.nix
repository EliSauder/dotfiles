{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.darwin-general;
in
{
  imports = [
    ./programs
    ./ui
  ];

  options.module = {
    darwin-general.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      autostart.enable = true;
    };
  };
}
