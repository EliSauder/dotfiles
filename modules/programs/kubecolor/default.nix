{
  config,
  lib,
  pkgs,
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
    home.packages = [
      pkgs.kubectl
    ];

    programs.kubecolor = {
      enable = true;
      enableZshIntegration = true;
      enableAlias = true;
    };

    programs.fish = {
      functions = {
        kubectl = "kubecolor";
      };
    };
  };
}
