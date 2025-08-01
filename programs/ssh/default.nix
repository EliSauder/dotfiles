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
      "~/.1password/agent.sock"
    else
      "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  options.prog = {
    ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        Host *
          IdentityAgent ${onePassPath}
      '';
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          identityFile = "${config.home.homeDirectory}/.ssh/git_ed25519";
        };
      };
    };

    services.ssh-agent.enable = isLinux;

    services.yubikey-agent.enable = true;
  };
}
