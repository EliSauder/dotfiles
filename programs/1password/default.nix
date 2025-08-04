{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.onepassword;
  isLinux = pkgs.stdenv.isLinux;
  onePassSignPath =
    if isLinux then
      "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}"
    else
      "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  onePassAgentPath =
    if isLinux then
      "~/.1password/agent.sock"
    else
      "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  options.prog = {
    onepassword.enable = lib.mkEnableOption "Enable onepassword";
    onepassword.sshIntegration = lib.mkOption {
      default = false;
    };
    onepassword.gitIntegration = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs._1password-gui
      pkgs._1password-cli
    ];

    programs.ssh = lib.mkIf cfg.sshIntegration {
      extraConfig = ''
        Host *
          IdentityAgent ${onePassAgentPath}
      '';
    };

    programs.git = lib.mkIf cfg.gitIntegration {
      extraConfig = {
        "gpg \"ssh\"" = {
          program = "${onePassSignPath}";
        };
      };
    };
  };
}
