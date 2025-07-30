{ pkgs, ... }:
let
  commitlintConfig = pkgs.writeText "commitlint.config.js" ''
    export default { extends: ['@commitlint/config-conventional'] };
  '';
in
{
  home.packages = [
    pkgs.commitlint
  ];

  programs.nixvim.plugins = {

    lint = {
      enable = true;
      lintersByFt = {
        gitcommit = [ "commitlint" ];
        tflint = [
          "terraform"
          "terraform-vars"
        ];
      };

      linters.commitlint = {
        args = [
          "--config"
          "${commitlintConfig}"
        ];
      };
      autoCmd.nested = true;
      autoCmd.event = [
        "BufEnter"
        "BufWritePost"
        "InsertLeave"
      ];
    };
  };
}
