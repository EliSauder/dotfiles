{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ui.mako;
in
{
  options.ui = {
    mako.enable = lib.mkEnableOption "Enable Mako";
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      icons = true;
      sort = "-priority";
      defaultTimeout = 5000;
      groupBy = "app-name,urgency";
    };
  };
}
