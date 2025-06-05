{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.gitws;
in
{
  options.prog = {
    gitws.enable = lib.mkEnableOption "Enable git worktree switcher";
  };

  config = lib.mkIf cfg.enable {
    programs.git-worktree-switcher = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
