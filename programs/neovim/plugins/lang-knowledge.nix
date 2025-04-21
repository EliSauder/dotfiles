{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      folding = true;

      settings = {
        auto_install = false;
        highlight = {
          additional_vim_regex_highlighting = true;
          enable = true;
        };

        indent.enable = true;
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        c_sharp
        cmake
        comment
        cpp
        css
        csv
        dockerfile
        doxygen
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gomod
        graphql
        html
        http
        javascript
        json
        json5
        jsonc
        latex
        lua
        luap
        make
        markdown
        markdown_inline
        nix
        regex
        rust
        sql
        ssh_config
        toml
        vim
        vimdoc
        xml
        yaml
        zig
      ];
    };

    # treesitter-context = {
    #   enable = true;
    #   settings.settings = {
    #     max_lines = 2;
    #     multiline_threashold = 2;
    #   };
    #   luaConfig.post = ''
    #     vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
    #     vim.cmd("hi TreesitterContextLineNumberBottom gui=underline guisp=Grey")
    #   '';
    # };

    treesitter-textobjects = {
      enable = true;
      lspInterop.enable = true;
      select.enable = true;
      move.enable = true;
    };

    lsp = {
      enable = true;
      inlayHints = true;
      preConfig = ''
        vim.diagnostic.config({
            underline = true,
            severity_sort = true
        })
      '';

      servers = {
        bashls = {
          enable = true;
          package = pkgs.bash-language-server;
        };
        clangd = {
          enable = true;
          package = pkgs.libclang;
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "cuda"
          ];
          settings = {
            checkUpdates = true;
            detectExtensionConflicts = true;
            enableCodeCompletion = true;
            restartAfterCrash = true;
            semanticHighlighting = true;
            serverCompletionRanking = true;
          };
        };
        cmake = {
          enable = true;
          package = pkgs.cmake-language-server;
        };
        omnisharp = {
          enable = true;

          settings = {
            enableEditorConfigSupport = true;
            enableImportCompletion = true;
            enableRoslynAnalyzers = true;
            organizeImportsOnFormat = true;
          };
          onAttach.function = ''
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          '';
        };
        #csharp_ls = {
        #    enable = true;
        #    package = pkgs.csharp-ls;
        #    onAttach.function = ''
        #        client.server_capabilities.documentFormattingProvider = false
        #        client.server_capabilities.documentRangeFormattingProvider = false
        #    '';
        #};
        jsonls = {
          enable = true;
          package = pkgs.vscode-langservers-extracted;
        };
        lua_ls = {
          enable = true;
          package = pkgs.lua-language-server;
          settings = {
            telemetry.enable = false;
            hint.enable = true;
          };
        };
        lemminx = {
          enable = true;
          package = pkgs.lemminx;
        };
        yamlls = {
          enable = true;
          package = pkgs.yaml-language-server;
          settings = {
            redhat.telemetry.enabled = false;
            yaml = {
              completion = true;
              disableAdditionalProperties = false;
              hover = true;
              maxItemsComputed = 5000;
              schemaStore = {
                enable = true;
                url = "https://www.schemastore.org/api/json/catalog.json";
              };
              tracke.server = "off";
              validate = true;
              format = {
                enable = true;
                singleQuote = false;
                bracketSpacing = true;
                printWidth = 80;
                proseWrap = "preserve";
              };
              keyOrdering = false;
              schemas = {
                "https://json.schemastore.org/clang-format.json" = ".clang-format";
                "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*";
                "https://json.schemastore.org/clangd.json" = ".clangd";
              };
            };
          };
        };

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
          rustcPackage = pkgs.rustc;
          cargoPackage = pkgs.cargo;
          rustfmtPackage = pkgs.rustfmt;
        };
        taplo = {
          enable = true;
          package = pkgs.taplo;
        };
        gopls = {
          enable = true;
          package = pkgs.gopls;
          settings.gopls = {
            completeUnimported = true;
            usePlaceholders = true;
            semanticTokens = true;
            analyses = {
              unusedparams = true;
              unusedwrite = true;
              useany = true;
              shadow = true;
            };
            staticcheck = true;
          };
        };
        zls = {
          enable = true;
          package = pkgs.zls;
        };
        ziggy = {
          enable = true;
          package = pkgs.ziggy;
          cmd = [
            "${pkgs.ziggy}/bin/ziggy"
            "lsp"
          ];
          filetypes = [
            "ziggy"
            "ziggy_schema"
          ];
        };
        superhtml = {
          enable = true;
          package = pkgs.superhtml;
          cmd = [
            "${pkgs.superhtml}/bin/superhtml"
            "lsp"
          ];
          filetypes = [ "superhtml" ];
        };
        nil_ls = {
          enable = true;
          settings.formatting.command = [ ];
          onAttach.function = ''
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          '';
        };
        nixd = {
          enable = true;
          settings.formatting.command = [ ];
          onAttach.function = ''
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          '';
        };
      };
    };
  };
}
