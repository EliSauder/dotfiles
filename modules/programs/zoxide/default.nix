{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.zoxide;
in
{
  options.prog = {
    zoxide.enable = lib.mkEnableOption "Enable zoxide";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fzf
    ];

    home.sessionVariables = {
      "_ZO_EXCLUDE_DIRS" = "/run/user/*";
    };

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
