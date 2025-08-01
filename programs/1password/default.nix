{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.ssh;
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  onePassPath =
    if isLinux then
      "${lib.getExe pkgs._1password-gui "op-ssh-sign"}"
    else
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
in
{
  options.prog = {
    onepassword.enable = lib.mkEnableOption "Enable onepassword";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs._1password-gui
      pkgs._1password-cli
    ];

    programs.ssh = {
      extraConfig = ''
        Host *
          IdentityAgent ${onePassPath}
      '';
    };

    programs.git = {
      extraConfig = {
        "gpg \"ssh\"" = {
          program = "${onePassPath}";
        };
      };
    };
  };
}
