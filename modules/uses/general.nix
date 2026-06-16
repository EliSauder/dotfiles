{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.general;
in
{
  imports = [
    ../programs
    ../ui
  ];

  options.module = {
    general.enable = lib.mkEnableOption "Enable development module";
    general.username = lib.mkOption {
      default = "emarusawa";
    };
    general.commandPrefix = lib.mkOption {
      default = "";
    };
    general.uses = lib.mkOption {
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    prog.inkscape.enable = true;
    prog.libreoffice = {
      enable = true;
      commandPrefix = cfg.commandPrefix;
    };

    prog.firefox = {
      enable = true;
      setdefault = false;
    };

    prog.qutebrowser = {
      enable = true;
      setDefault = true;
      package = pkgs.qutebrowser-dev;
    };

    prog.onepassword = {
      enable = true;
      gitIntegration = (builtins.elem "personal" cfg.uses) && (builtins.elem "development" cfg.uses);
      sshIntegration = (builtins.elem "personal" cfg.uses) && (builtins.elem "development" cfg.uses);
      username = cfg.username;
    };
  };
}
