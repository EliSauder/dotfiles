{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.general-linux;
in
{
  options.module = {
    general-linux.enable = lib.mkEnableOption "Enable general module";
  };

  config = lib.mkIf cfg.enable {
    prog.qutebrowser = {
      enable = true;
      setDefault = true;
      package = pkgs.qutebrowser-dev;
    };
  };
}
