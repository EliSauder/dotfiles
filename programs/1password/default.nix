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
  onePassSignPath =
    if isLinux then
      "${lib.getExe pkgs._1password-gui "op-ssh-sign"}"
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
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs._1password-gui
      pkgs._1password-cli
    ];

    programs.ssh = {
      extraConfig = ''
        Host *
          IdentityAgent ${onePassAgentPath}
      '';
    };

    programs.git = {
      extraConfig = {
        "gpg \"ssh\"" = {
          program = "${onePassSignPath}";
        };
      };
    };
  };
}
