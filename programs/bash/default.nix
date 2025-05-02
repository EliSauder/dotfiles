{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.bash;
in
{
  options.prog = {
    bash.enable = lib.mkEnableOption "Enable bash";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fish
    ];

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        fish
      '';
    };
  };
}
