{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.git;
in
{
  options.prog = {
    git.enable = lib.mkEnableOption "Enable git";
    git.editor = lib.mkOption {
      type = with lib.types; uniq str;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.difftastic
    ];

    programs.git = {
      enable = true;
      package = pkgs.git.override {
        guiSupport = true;
        withLibsecret = true;
        withSsh = true;
        svnSupport = true;
      };
      settings = {
        user = {
          name = "EliSauder";
          email = "24995216+EliSauder@users.noreply.github.com";
        };
        aliases = {
          s = "status";
          co = "checkout";
          cob = "checkout -b";
        };
        pull = {
          rebase = true;
        };
        core = {
          editor = "${cfg.editor}";
        };
      };
      lfs.enable = true;
      signing = {
        key = "${config.home.homeDirectory}/.ssh/git_ed25519.pub";
        signByDefault = true;
        format = "ssh";
      };
      maintenance.enable = true;
    };

    programs.difftastic = {
      enable = true;
      git.diffToolMode = true;
      git.enable = true;
    };

  };
}
