{
  config,
  lib,
  ...
}:
let
  cfg = config.prog.libreoffice;
in
{
  options.prog = {
    kubecolor.enable = lib.mkEnableOption "Enable libreoffice";
  };

  config = lib.mkIf cfg.enable {
    programs.kubecolor = {
      enable = true;
      enableZshIntegration = true;
      enableAlias = true;
    };
  };
}
