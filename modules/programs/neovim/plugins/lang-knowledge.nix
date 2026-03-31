{ pkgs, lib, ... }:
{
  #home.packages = [
  #  pkgs.dotnet-ef
  #  pkgs.netcoredbg
  #  pkgs.vscode-langservers-extracted
  #  pkgs.nixd
  #  pkgs.omnisharp-roslyn
  #  pkgs.gopls
  #  pkgs.tree-sitter
  #  pkgs.nodejs-slim
  #];

  home.packages = [
    pkgs.impl
  ];

  programs.nixvim.extraPlugins = [
    pkgs.vimPlugins.vim-go
    (pkgs.vimUtils.buildVimPlugin {
      name = "go-impl";
      src = pkgs.fetchFromGitHub {
        owner = "EliSauder";
        repo = "go-impl.nvim";
        rev = "a895ee26772325a2d4baba4a1224e6ede7857ee6";
        hash = "sha256-NVcO2n4HnYx4P02jXqA5GCaXiN8ukc40BvJMpKucSSs=";
      };
      doCheck = false;
      buildInputs = [
        pkgs.impl
        pkgs.fzf
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.nui-nvim
        pkgs.vimPlugins.snacks-nvim
      ];
      dependencies = [
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.nui-nvim
        pkgs.vimPlugins.snacks-nvim
      ];
    })
  ];

  programs.nixvim.extraConfigLua = ''
    require("go-impl").setup({})
  '';

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
        proto
        python
        regex
        ron
        rust
        sql
        ssh_config
        terraform
        toml
        vim
        vimdoc
        xml
        yaml
        zig
      ];
    };

    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 2;
        multiline_threashold = 1;
        line_numbers = true;
      };
      luaConfig.post = ''
        vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
        vim.cmd("hi TreesitterContextLineNumberBottom gui=underline guisp=Grey")
      '';
    };

    treesitter-textobjects = {
      enable = true;
      settings = {
        lsp_interop.enable = true;
        move.enable = true;
        select.enable = true;
      };
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
        config = {
          filetypes = [
            "sh"
            "bash"
          ];
          root_markers = [ ".git" ];
          cmd = [
            "bash-language-server"
            "start"
          ];
          settings = {
            bashIde = {
              globPattern.__raw = "vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)'";
            };
          };
        };
      };
      pylsp = {
        enable = true;
        config = {
          cmd = [ "pylsp" ];
          filetypes = [ "python" ];
          root_markers = [
            "pyproject.toml"
            "setup.py"
            "setup.cfg"
            "requirements.txt"
            "Pipfile"
            ".git"
          ];
        };
      };
      clangd = {
        enable = true;
        package = pkgs.libclang;
        config = {
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "cuda"
          ];

          cmd = [ "clangd" ];

          root_markers = [
            ".clangd"
            ".clang-tidy"
            ".clang-format"
            "compile_commands.json"
            "compile_flags.txt"
            "configure.ac"
            ".git"
          ];

          capabilities = {
            textDocument = {
              completion = {
                editsNearCursor = true;
              };
            };

            offsetEncoding = [
              "utf-8"
              "utf-16"
            ];
          };

          on_init.__raw = ''
            function(client, init_result)
              if init_result.offsetEncoding then
                client.offset_encoding = init_result.offsetEncoding
              end
            end
          '';

          settings = {
            checkUpdates = false;
            detectExtensionConflicts = true;
            enableCodeCompletion = true;
            restartAfterCrash = true;
            semanticHighlighting = true;
            serverCompletionRanking = true;
          };
        };
      };
      cmake = {
        enable = true;
        config = {
          cmd = [ "cmake-language-server" ];
          filetypes = [ "cmake" ];
          root_markers = [
            "CMakePresets.json"
            "CTestConfig.cmake"
            ".git"
            "build"
            "cmake"
          ];
          init_options = {
            buildDirectory = "build";
          };
        };
      };
      omnisharp = {
        enable = true;
        package = pkgs.omnisharp-roslyn;

        config = {
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
            ".slnx"
            ".csproj"
            "omnisharp.json"
            "function.json"
          ];

          cmd.__raw = ''
            {
                vim.fn.executable('OmniSharp') == 1 and 'OmniSharp' or 'omnisharp',
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
        config = {
          cmd = [
            "vscode-json-language-server"
            "--stdio"
          ];
          json = {
            format = {
              enable = true;
            };
            trace = {
              server = "off";
            };
          };
          filetypes = [
            "json"
            "jsonc"
          ];
          init_options = {
            provideFormatter = true;
          };
          root_markers = [
            ".git"
          ];
        };
      };
      lua_ls = {
        enable = true;
        package = pkgs.lua-language-server;
        config = {
          cmd = [ "lua-language-server" ];
          filetypes = [ "lua" ];
          root_markers = [
            ".emmyrc.json"
            ".luarc.json"
            ".luarc.jsonc"
            ".luacheckrc"
            ".stylua.toml"
            "stylua.toml"
            "selene.toml"
            "selene.yml"
            ".git"
          ];
          settings = {
            Lua = {
              codeLens.enable = true;
              telemetry.enable = false;
              hint.enable = true;
            };
          };
        };
      };
      lemminx = {
        enable = true;
        package = pkgs.lemminx;
        config = {

          cmd = [ "lemminx" ];
          filetypes = [
            "xml"
            "xsd"
            "xsl"
            "xslt"
            "svg"
          ];
          root_markers = [ ".git" ];
        };
      };
      yamlls = {
        enable = true;
        package = pkgs.yaml-language-server;
        config = {
          cmd = [
            "yaml-language-server"
            "--stdio"
          ];
          filetypes = [
            "yaml"
            "yaml.docker-compose"
            "yaml.gitlab"
            "yaml.helm-values"
          ];
          root_markers = [
            ".git"
          ];
          on_init.__raw = ''
            function(client)
              client.server_capabilities.documentFormattingProvider = true
            end
          '';
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
              track.server = "off";
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
      };

      rust_analyzer = {
        enable = true;
        package = pkgs.rust-analyzer;
        config = {
          filetypes = [ "rust" ];
          cmd = [ "rust-analyzer" ];
          capabilities = {
            experimental = {
              serverStatusNotification = true;
              commands = {
                commands = [
                  "rust-analyzer.showReferences"
                  "rust-analyzer.runSingle"
                  "rust-analyzer.debugSingle"
                ];
              };
            };
          };

          settings = {
            rust-analyzer = {
              lens = {
                debug.enable = true;
                enable = true;
                implementations.enable = true;
                references = {
                  adt.enable = true;
                  enumVariant.enable = true;
                  method.enable = true;
                  trait.enable = true;
                };
                run.enable = true;
                updateTest.enable = true;
              };
            };
          };

          root_dir.__raw = ''
            function(bufnr, on_dir)
              local fname = vim.api.nvim_buf_get_name(bufnr)
              -- is_library
              local user_home = vim.fs.normalize(vim.env.HOME)
              local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
              local registry = cargo_home .. '/registry/src'
              local git_registry = cargo_home .. '/git/checkouts'

              local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
              local toolchains = rustup_home .. '/toolchains'

              local reused_dir

              for _, item in ipairs { toolchains, registry, git_registry } do
                if vim.fs.relpath(item, fname) then
                  local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
                  reused_dir = #clients > 0 and clients[#clients].config.root_dir or nil
                  break
                end
              end

              -- end is_library

              if reused_dir then
                on_dir(reused_dir)
                return
              end

              local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
              local cargo_workspace_root

              if cargo_crate_dir == nil then
                on_dir(
                  vim.fs.root(fname, { 'rust-project.json' })
                    or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
                )
                return
              end

              local cmd = {
                'cargo',
                'metadata',
                '--no-deps',
                '--format-version',
                '1',
                '--manifest-path',
                cargo_crate_dir .. '/Cargo.toml',
              }

              vim.system(cmd, { text = true },
                function(output)
                  if output.code == 0 then
                    if output.stdout then
                      local result = vim.json.decode(output.stdout)
                      if result['workspace_root'] then
                        cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
                      end
                    end

                    on_dir(cargo_workspace_root or cargo_crate_dir)
                  else
                    vim.schedule(
                      function()
                        vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
                      end)
                  end
                end)
            end
          '';
        };
      };
      taplo = {
        enable = true;
        package = pkgs.taplo;
        config = {
          cmd = [
            "taplo"
            "lsp"
            "stdio"
          ];
          filetypes = [ "toml" ];
          root_markers = [
            ".taplo.toml"
            "taplo.toml"
            ".git"
          ];
        };
      };
      # codespell:ignore-begin
      protols = {
        # codespell:ignore-end
        enable = true;
        package = pkgs.protobuf-language-server;
        config = {
          filetypes = [ "proto" ];
          cmd = [
            "protobuf-language-server"
          ];
          root_markers = [
            ".git"
          ];
        };
      };
      buf_ls = {
        enable = false;
        package = pkgs.buf;
        config = {
          filetypes = [ "proto" ];
          cmd = [
            "${pkgs.buf}/bin/buf"
            "lsp"
            "serve"
            "--timeout=0"
            "--log-format=text"
          ];
          root_markers = [
            "buf.yaml"
            ".git"
          ];
          reuse_client.__raw = ''
            function(client, config)
              return client.name == config.name
            end
          '';
        };
      };
      gopls = {
        enable = true;
        package = pkgs.gopls;
        config = {
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

          cmd = [ "${pkgs.gopls}/bin/gopls" ];

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
        config = {

          cmd = [ "zls" ];
          filetypes = [
            "zig"
            "zir"
          ];
          root_markers = [
            "zls.json"
            "build.zig"
            ".git"
          ];
          workspace_required = false;
        };
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
        config = {
          cmd = [
            "${pkgs.superhtml}/bin/superhtml"
            "lsp"
          ];
          filetypes = [ "superhtml" ];
        };
      };
      nil_ls = {
        enable = true;
        config = {
          cmd = [ "nil" ];
          filetypes = [ "nix" ];
          root_markers = [
            "flake.nix"
            ".git"
          ];
          on_attach.__raw = ''
            function(client, bufnr)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          '';
        };
      };
      terraformls = {
        enable = true;
        config = {
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
        config = {
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
