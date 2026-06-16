{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.ssh;
  isLinux = pkgs.stdenv.isLinux;
  #isDarwin = pkgs.stdenv.isDarwin;
in
{
  options.prog = {
    ssh.enable = lib.mkEnableOption "Enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          HashKnownHosts = true;
          ForwardAgent = false;
          AddKeysToAgent = "confirm";
          ServerAliveInterval = 3;
          ServerAliveCountMax = 3;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/master-%r@%h:%p";
          ControlPersist = "2h";
        };
        github = lib.hm.dag.entryAfter [ "*" ] {
          HostName = "github.com";
          User = "git";
          IdentityFile = "${config.home.homeDirectory}/.ssh/git_ed25519";
        };
        hme = lib.hm.dag.entryAfter [ "*" ] {
          HostName = "*.hme.com";
          IdentityFile = "${config.home.homeDirectory}/.ssh/servers_ed25519";
        };
      };
    };

    services.ssh-agent.enable = isLinux;

    #services.yubikey-agent.enable = true;
  };
}
