{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ui.cliphist;
in
{
  options.ui = {
    cliphist.enable = lib.mkEnableOption "enable cliphist";
  };

  config = lib.mkIf cfg.enable {
    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
