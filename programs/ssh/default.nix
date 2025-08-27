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
in
{
  options.prog = {
    ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          hashKnownHosts = true;
          forwardAgent = false;
          addKeysToAgent = "yes";
          serverAliveInterval = 3;
          serverAliveCountMax = 3;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPath = "~/.ssh/master-%r@%h:%p";
          controlPersist = "2h";
        };
        github = lib.hm.dag.entryAfter [ "*" ] {
          hostname = "github.com";
          addKeysToAgent = "yes";
          identityFile = "${config.home.homeDirectory}/.ssh/git_ed25519";
        };
      };
    };

    services.ssh-agent.enable = isLinux;

    services.yubikey-agent.enable = true;
  };
}
