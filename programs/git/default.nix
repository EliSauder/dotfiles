{config, types, pkgs, lib, ... }: 
let
    cfg = config.prog.git;
in {
    options.prog = {
        git.enable = lib.mkEnableOption "Enable git";
        git.editor = lib.mkOption {
            type = with types; uniq str; 
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.difftastic
        ];

        programs.git = {
          enable = true;
          userName = "EliSauder";
          userEmail = "24995216+EliSauder@users.noreply.github.com";
          lfs.enable = true;
          signing = {
              key = "${config.home.homeDirectory}/.ssh/git_ed25519";
              signByDefault = true;
          };
          extraConfig = {
              gpg = {
                  format = "ssh";
              };
              core = {
                  editor = "${cfg.editor}";
              };
          };
          maintenance.enable = true;
          aliases = {
            s = "status";
            co = "checkout";
            cob = "checkout -b";
          };
          difftastic.enable = true;
        };

    };
}
