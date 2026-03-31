{
  config,
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
    darwin-general.username = lib.mkOption {
      default = "emarusawa";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      autostart.enable = true;
    };
  };
}
