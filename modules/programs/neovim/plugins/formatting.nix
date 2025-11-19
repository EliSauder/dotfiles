{ pkgs, ... }:
{
  home.packages = [
    pkgs.libclang
    pkgs.codespell
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
          "_" = [
            "trim_whitespace"
            "trim_newlines"
          ];
          "*" = [ "codespell" ];
        };

        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };

        formatters = {
          clang-format = {
            command = "${pkgs.libclang}/bin/clang-format";
          };
          codespell = {
            command = "${pkgs.codespell}/bin/codespell";
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
