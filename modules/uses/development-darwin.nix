{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.development-darwin;
in
{
  options.module = {
    development-darwin.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
  };
}
