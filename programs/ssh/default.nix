{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.ssh;
in
{
  options.prog = {
    ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          identityFile = "${config.home.homeDirectory}/.ssh/git_ed25519";
        };
      };
    };

    services.ssh-agent.enable = true;
    services.yubikey-agent.enable = true;
  };
}
