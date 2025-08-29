{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.ui.wofi;
in
{
  options.ui = {
    wofi.enable = lib.mkEnableOption "Enable Wofi";
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
    };
  };
}
