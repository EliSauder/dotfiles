{config, lib, pkgs, ... }: 
let
    cfg = config.prog.ssh;
in {
    options.prog = {
        ssh.enable = lib.mkEnableOption "Enable ssh";
    };

    config = lib.mkIf cfg.enable {
        programs.ssh = {
            enable = true;
            addKeysToAgent = "confirm 2h";
            matchBlocks = {
                "github.com" = {
                    hostname = "github.com";
                    identityFile = "${config.home.homeDirectory}/.ssh/git_ed25519";
                };
            };
        };
    };
}
