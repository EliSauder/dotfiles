{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules;
in
{
  imports = [
    ../programs
    ../ui
    ./personal.nix
    ./work.nix
    ./development.nix
  ];

  options.modules = {
    enable = lib.mkEnableOption "Enable development module";
    uses = lib.mkOption {
      default = [ ];
    };
    username = lib.mkOption {
      default = "emarusawa";
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
      gitIntegration = builtins.elem "personal" cfg.uses && builtins.elem "development" cfg.uses;
      sshIntegration = builtins.elem "personal" cfg.uses && builtins.elem "development" cfg.uses;
      username = cfg.username;
    };

    module.work = lib.mkIf builtins.elem "work" cfg.uses {
      enable = true;
    };

    module.personal = lib.mkIf builtins.elem "personal" cfg.uses {
      enable = true;
    };

    module.development = lib.mkIf builtins.elem "development" cfg.uses {
      enable = true;
      enableDotnet7 = lib.mkIf builtins.elem "work" cfg.uses;
    };
  };
}
