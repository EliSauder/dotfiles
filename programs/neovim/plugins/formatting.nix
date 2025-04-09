{pkgs, ...}: {
  programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = ["nixfmt"];
          flake = ["nixfmt"];
          cs = ["clang-format"];
          "_" = ["trim_whitespace" "trim_newlines"];
          "*" = ["codespell"];
        };

        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };

        formatters = {
          clang-format = {command = "${pkgs.libclang}/bin/clang-format";};
          codespell = {command = "${pkgs.codespell}/bin/codespell";};
          nixfmt = {command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";};
        };
      };
    };
  };
}
