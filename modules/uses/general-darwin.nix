{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.general-darwin;
in
{
  imports = [
    ../programs
  ];

  options.module = {
    general-darwin.enable = lib.mkEnableOption "Enable general module";
  };

  config = lib.mkIf cfg.enable {
    prog.qutebrowser = {
      enable = false;
    };
  };
}
