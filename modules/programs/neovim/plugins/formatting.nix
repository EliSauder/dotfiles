{ pkgs, pkgs-unstable, ... }:
{
  home.packages = [
    pkgs.libclang
    pkgs.nixfmt
    pkgs.fixjson
    pkgs.grafana-alloy
    pkgs.sqlfluff
    pkgs.buf
  ];

  programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          sql = [ "sqlfluff" ];
          mysql = [ "sqlfluff" ];
          plsql = [ "sqlfluff" ];
          msql = [ "sqlfluff" ];
          nix = [ "nixfmt" ];
          flake = [ "nixfmt" ];
          cs = [ "clang-format" ];
          json = [ "fixjson" ];
          alloy = [ "alloyfmt" ];
          proto = [ "buffmt" ];
          "_" = [
            "trim_whitespace"
            "trim_newlines"
          ];
        };

        format_after_save = {
          lsp_format = "fallback";
        };

        formatters = {
          sqlfluff = {
            args = [
              "format"
              "-"
            ];
          };
          buffmt = {
            command = "buf";
            args = [
              "format"
              "$FILENAME"
              "-w"
            ];
            stdin = false;
          };
          clang-format = {
            command = "${pkgs.libclang}/bin/clang-format";
          };
          nixfmt = {
            command = "${pkgs.nixfmt}/bin/nixfmt";
          };
          fixjson = {
            command = "${pkgs.fixjson}/bin/fixjson";
          };
          alloyfmt = {
            command = "${pkgs.grafana-alloy}/bin/alloy";
            stdin = true;
            args = [
              "fmt"
            ];
          };
        };
      };
    };
  };
}
