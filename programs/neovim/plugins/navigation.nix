{pkgs, ...}: {
  programs.nixvim.plugins = {
    oil = {
      enable = true;
      autoLoad = true;
      settings = {
        use_default_keymaps = false;
        keymaps = {"<CR>" = "actions.select";};
      };
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
  };
}
