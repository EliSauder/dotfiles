{
  config,
  lib,
  ...
}:
let
  cfg = config.platform.darwin;
in
{
  imports = [
    ../programs
    ../ui
  ];

  options.platform = {
    darwin.enable = lib.mkEnableOption "Enable development module";
    darwin.username = lib.mkOption {
      default = "emarusawa";
    };
    darwin.homeDirectory = lib.mkOption {
      default = "/Users/${cfg.username}";
    };
  };

  config = lib.mkIf cfg.enable {
    home.username = cfg.username;
    home.homeDirectory = cfg.homeDirectory;
    xdg = {
      enable = true;
      autostart.enable = true;
    };
  };
}
