{pkgs, ...}: {
  programs.nixvim.plugins = {
    lint = {
      enable = true;
      lintersByFt = {
        gitcommit = ["${pkgs.commitlint-rs}/bin/commitlint"];
      };
      autoCmd.event = ["BufEnter" "BufWritePost" "InsertLeave"];
    };
  }
}
