{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.grc;
in
{
  options.prog = {
    grc.enable = lib.mkEnableOption "Enable git";
    grc.package = lib.mkPackageOption pkgs "grc" { example = "grc"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.grc
    ];

    home.file = {
      ".grc/grc.conf".text = ''
        # Go
        ^([/\w\.]+\/)?go test\b
        conf.gotest
      '';
      ".grc/conf.gotest".text = ''
        # go-test grc colorizer configuration
        regexp==== RUN .*
        colour=bright_blue
        -
        regexp=--- PASS: .* (\(\d+\.\d+s\))
        colour=green, yellow
        -
        regexp=^PASS$
        colour=bold white on_green
        -
        regexp=^(ok|FAIL)\s+.*
        colour=default, magenta
        -
        regexp=--- FAIL: .* (\(\d+\.\d+s\))
        colour=red, yellow
        -
        regexp=^FAIL$
        colour=bold white on_red
        -
        regexp=[^\s]+\.go(:\d+)?
        colour=cyan
      '';
    };

    programs.fish.functions = {
      go = "grc go $argv";
    };

  };
}
