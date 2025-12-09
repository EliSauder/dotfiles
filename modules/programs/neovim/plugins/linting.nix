{ pkgs, config, ... }:
let
  commitlintConfig = pkgs.writeText "commitlint.config.js" ''
    export default { extends: ['@commitlint/config-conventional'] };
  '';
  helpers = config.lib.nixvim;

  apiLinterWrapper = "${pkgs.writeShellScriptBin "apilinterwrapper.sh" ''
    #!/bin/bash

    relpath() {
      x=`pwd`
      while [[ "$x" != "/" && "$dir" != "$HOME" ]] ; do
        if [ -f "$x/buf.yaml" ]; then
          break
        fi
        if [ -f "$x/buf.yml" ]; then
          break
        fi
        x=`dirname "$x"`
      done

      realpath -m --relative-to="$x" -- "$1"
    }

    out_args=()

    for arg in "$@"; do
      if [[ "$arg" == --* ]]; then
        out_args+=("$arg")
      else
        out_args+=("$(relpath "$arg")")
      fi
    done

    exec "${pkgs.api-linter}/bin/api-linter" "''${out_args[@]}"
  ''}/bin/apilinterwrapper.sh";
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
        proto = [
          "api_linter"
          "buf_lint"
        ];
        terraform = [
          "tflint"
        ];
        terraform-vars = [
          "tflint"
        ];
      };

      customLinters = {
        api_linter = {
          cmd = "${apiLinterWrapper}";
          stdin = false;
          append_fname = true;
          args = [
            "--output-format=json"
            (helpers.mkRaw "descriptor_set_in")
            (helpers.mkRaw "find_config")
          ];
          stream = "both";
          #ignore_exitcode = true;
          #env = null;
          parser.__raw = ''
            function(output, bufnr, linter_cwd)
              if output == "" then
                return {}
              end
              local json_output = vim.json.decode(output)
              local diagnostics = {}
              if json_output == nil then
                return diagnostics
              end
              for _, item in ipairs(json_output) do
                for _, problem in ipairs(item.problems) do
                  table.insert(diagnostics, {
                    message = problem.message,
                    file = item.file_path,
                    code = problem.rule_id,
                    source = problem.rule_doc_uri,
                    severity = vim.diagnostic.severity.WARN,
                    lnum = problem.location.start_position.line_number - 1,
                    col = problem.location.start_position.column_number - 1,
                    end_lnum = problem.location.end_position.line_number - 1,
                    end_col = problem.location.end_position.column_number - 1,
                    user_data = {
                      suggestion = problem.suggestion
                    },
                  })
                end
              end
              cleanup_descriptor()
              return diagnostics
            end
          '';
        };
      };

      linters = {
        commitlint = {
          args = [
            "--config"
            "${commitlintConfig}"
          ];
        };
      };
      autoCmd.nested = true;
      autoCmd.event = [
        "BufEnter"
        "BufWritePost"
        "InsertLeave"
      ];

      luaConfig.pre = ''
        function dump(o)
           if type(o) == 'table' then
              local s = '{ '
              for k,v in pairs(o) do
                 if type(k) ~= 'number' then k = '"'..k..'"' end
                 s = s .. '['..k..'] = ' .. dump(v) .. ','
              end
              return s .. '} '
           else
              return tostring(o)
           end
        end

        local cached_buf_config_filepath = nil

        local function find_file_upwards(names, start_path, stop_path)
          -- Normalize paths
          start_path = vim.fn.fnamemodify(start_path, ":p")
          stop_path = vim.fn.fnamemodify(stop_path, ":p")

          local current_dir = start_path
          while current_dir >= stop_path do
            for _, name in ipairs(names) do
              local file_path = current_dir .. "/" .. name
              if vim.fn.filereadable(file_path) == 1 then
                return file_path
              end
            end
            -- Go up one directory
            local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
            if parent_dir == current_dir then
              break
            end
            current_dir = parent_dir
          end

          return nil
        end

        local descriptor_filepath = os.tmpname()

        local function find_config()
          local buffer_parent_dir = vim.fn.getcwd()
          local config_filepath = find_file_upwards({"api-linter.yaml", "api-linter.yml"}, buffer_parent_dir, vim.fn.expand("~"))
            or find_file_upwards({"api-linter.yaml"}, buffer_parent_dir)
          if not config_filepath then
            return nil
          end
          return "--config=" .. config_filepath
        end

        local function descriptor_set_in()
          if vim.fn.executable("buf") == 0 then
            error("buf CLI not found")
          end

          local buffer_parent_dir = vim.fn.getcwd()
          local buf_config_filepath = find_file_upwards({ "buf.yaml", "buf.yml" }, buffer_parent_dir, vim.fn.expand("~"))
            or find_file_upwards({"buf.yml"}, buffer_parent_dir)

          if not buf_config_filepath then
            error("Buf config file not found")
          end

          -- build the descriptor file.
          local buf_config_folderpath = vim.fn.fnamemodify(buf_config_filepath, ":h")
          local buf_cmd = string.format(
            "cd %s && buf build -o %s",
            vim.fn.shellescape(buf_config_folderpath),
            vim.fn.shellescape(descriptor_filepath)
          )
          local output = vim.fn.system(buf_cmd)
          local exit_code = vim.v.shell_error

          if exit_code ~= 0 then
            error("Command failed: " .. buf_cmd .. "\n" .. output)
          end

          -- return the argument to be passed to the linter.
          return "--descriptor-set-in=" .. descriptor_filepath
        end

        local cleanup_descriptor = function()
          os.remove(descriptor_filepath)
        end
      '';

    };
  };
}
