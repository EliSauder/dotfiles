{config, pkgs, ... }: {
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
}
