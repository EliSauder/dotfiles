{config, pkgs, ... }: {
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
            editor = "${pkgs.neovim}/bin/nvim";
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

}
