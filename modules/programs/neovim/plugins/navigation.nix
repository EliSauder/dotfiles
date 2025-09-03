{ pkgs, lib, ... }:
{

  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "oil-lsp-diagnostics";
      src = pkgs.fetchFromGitHub {
        owner = "JezerM";
        repo = "oil-lsp-diagnostics";
        rev = "e04e3c387262b958fee75382f8ff66eae9d037f4";
        hash = lib.fakeHash;
      };
    })
  ];

  programs.nixvim.extraConfigLua = ''
    require("oil-lsp-diagnostics").setup({})
  '';

  programs.nixvim.plugins = {
    oil = {
      enable = true;
      autoLoad = true;
      settings = {
        use_default_keymaps = false;
        default_file_explorer = true;
        keymaps = {
          "<CR>" = "actions.select";
        };
        win_options = {
          signcolumn = "yes:2";
        };
        view_options = {
          natural_order = true;
          show_hidden = true;
        };
      };
    };

    oil-git-status = {
      enable = true;
    };

    telescope = {
      enable = true;

      extensions = {
        frecency.enable = true;
        fzf-native.enable = true;
      };
    };

    harpoon = {
      enable = true;
      enableTelescope = true;
      settings.settings = {
        save_on_toggle = true;
        sync_on_ui_close = true;
      };
    };

    git-worktree = {
      enable = true;
      enableTelescope = true;
      settings = {
        clear_jumps_on_change = true;
      };
    };
  };

  programs.nixvim.extraConfigLuaPost = ''
    local Hooks = require("git-worktree.hooks")
    local config = require('git-worktree.config')
    local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

    Hooks.register(Hooks.type.SWITCH, function (path, prev_path)
      update_on_switch(path, prev_path)
      if vim.fn.expand("%"):find("^oil:///") then
        -- switch to new cwd in oil
        require("oil").open(vim.fn.getcwd())
      end
    end)

    Hooks.register(Hooks.type.DELETE, function ()
      vim.cmd(config.update_on_change_command)
    end)
  '';
}
