{ pkgs, ... }:
{
  home.packages = [
    pkgs.libclang
    pkgs.nixfmt-rfc-style
    pkgs.fixjson
    pkgs.grafana-alloy
  ];

  programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
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

        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };

        formatters = {
          buffmt = {
            command = "${pkgs.buf}/bin/buf";
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
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
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
