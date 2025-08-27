{ pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.dotnet-ef
    pkgs.netcoredbg
  ];
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

    easy-dotnet = {
      enable = true;
    };
  };

  programs.nixvim.lsp = {
    inlayHints.enable = true;
    #luaConfig.pre = ''
    #  vim.diagnostic.config({
    #      underline = true,
    #      severity_sort = true
    #  })
    #'';

    servers = {
      bashls = {
        enable = true;
        package = pkgs.bash-language-server;
      };
      clangd = {
        enable = true;
        package = pkgs.libclang;
        settings = {
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "cuda"
          ];
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
      };
      omnisharp = {
        enable = true;
        package = pkgs.omnisharp-roslyn;

        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true;
            OrganizeImports = true;
          };

          RoslynExtensionOptions = {
            enableImportCompletion = true;
            enableDecompilationSupport = true;
            enableAnalyzersSupport = true;
          };

          #on_attach.function = ''
          #    client.server_capabilities.documentFormattingProvider = false
          #    client.server_capabilities.documentRangeFormattingProvider = false
          #'';

          filetypes = [
            "cs"
            "vb"
          ];

          root_markers = [
            ".sln"
            ".csproj"
            "omnisharp.json"
            "function.json"
          ];

          cmd.__raw = ''
            {
                '${pkgs.omnisharp-roslyn}/bin/OmniSharp',
                '-z',
                '--hostPID',
                tostring(vim.fn.getpid()),
                'DotNet:enablePackageRestore=false',
                '--encoding',
                'utf-8',
                '--languageserver',
              }
          '';
          #root_dir.__raw = ''require('lspconfig.util').root_pattern("*.sln", "*.csproj")'';
        };
      };
      #csharp_ls = {
      #  enable = true;
      #  package = pkgs.csharp-ls;
      #  onAttach.function = ''
      #    client.server_capabilities.documentFormattingProvider = false
      #    client.server_capabilities.documentRangeFormattingProvider = false
      #  '';
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
        package = pkgs.rust-analyzer;
      };
      taplo = {
        enable = true;
        package = pkgs.taplo;
      };
      gopls = {
        enable = true;
        package = pkgs.gopls;
        settings = {
          filetypes = [
            "go"
            "gomod"
            "gowork"
            "gotmpl"
          ];

          root_markers = [
            "go.work"
            "go.mod"
            ".git"
          ];

          cmd = [ "gopls" ];

          gopls = {
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
      };
      zls = {
        enable = true;
        package = pkgs.zls;
      };
      #ziggy = {
      #  enable = true;
      #  package = pkgs.ziggy;
      #  cmd = [
      #    "${pkgs.ziggy}/bin/ziggy"
      #    "lsp"
      #  ];
      #  filetypes = [
      #    "ziggy"
      #    "ziggy_schema"
      #  ];
      #};
      superhtml = {
        enable = true;
        package = pkgs.superhtml;
        settings = {
          cmd = [
            "${pkgs.superhtml}/bin/superhtml"
            "lsp"
          ];
          filetypes = [ "superhtml" ];
        };
      };
      nil_ls = {
        enable = true;
        settings = {
          formatting.command = [ ];
          on_attach.function = ''
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          '';
        };
      };
      terraformls = {
        enable = true;
        settings = {
          root_markers = [
            ".terraform"
            ".git"
          ];
          cmd = [
            "terraform-ls"
            "serve"
          ];
          filetypes = [
            "terraform"
            "terraform-vars"
          ];
        };
      };
      nixd = {
        enable = true;
        settings = {
          formatting.command = [ ];
          #on_attach.function = ''
          #  client.server_capabilities.documentFormattingProvider = false
          #  client.server_capabilities.documentRangeFormattingProvider = false
          #'';
          cmd = [ "nixd" ];
          filetypes = [ "nix" ];
          root_markers = [
            "flake.nix"
            "git"
          ];
        };
      };
    };
  };
}
