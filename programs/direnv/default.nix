{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.direnv;
in
{
  options.prog = {
    direnv.enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
