{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = [
      # -- File viewer
      {
        mode = "n";
        key = "<leader>pv";
        action = "<cmd>Oil<cr>";
        options = {silent = true;};
      }

      # -- Colemak remap
      # Remap overwrites
      {
        mode = "n";
        key = "<leader>/";
        action = "/";
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "/";
      }
      {
        mode = "n";
        key = "<leader>m";
        action = "m";
      }
      {
        mode = "v";
        key = "<leader>m";
        action = "m";
      }
      {
        mode = "n";
        key = "<leader>.";
        action = ".";
      }
      {
        mode = "v";
        key = "<leader>.";
        action = ".";
      }
      {
        mode = "n";
        key = "<leader>,";
        action = ",";
      }
      {
        mode = "v";
        key = "<leader>,";
        action = ",";
      }

      {
        mode = "n";
        key = "<leader>?";
        action = "?";
      }
      {
        mode = "v";
        key = "<leader>?";
        action = "?";
      }
      {
        mode = "n";
        key = "<leader>M";
        action = "M";
      }
      {
        mode = "v";
        key = "<leader>M";
        action = "M";
      }
      {
        mode = "n";
        key = "<leader><";
        action = "<";
      }
      {
        mode = "v";
        key = "<leader>>";
        action = ">";
      }
      {
        mode = "n";
        key = "<leader><";
        action = "<";
      }
      {
        mode = "v";
        key = "<leader>>";
        action = ">";
      }

      # Map new keys
      {
        mode = "n";
        key = "m";
        action = "h";
      }
      {
        mode = "v";
        key = "m";
        action = "h";
      }
      {
        mode = "n";
        key = ",";
        action = "j";
      }
      {
        mode = "v";
        key = ",";
        action = "j";
      }
      {
        mode = "n";
        key = ".";
        action = "k";
      }
      {
        mode = "v";
        key = ".";
        action = "k";
      }
      {
        mode = "n";
        key = "/";
        action = "l";
      }
      {
        mode = "v";
        key = "/";
        action = "l";
      }

      {
        mode = "n";
        key = "M";
        action = "H";
      }
      {
        mode = "v";
        key = "M";
        action = "H";
      }
      {
        mode = "n";
        key = "<";
        action = "J";
      }
      {
        mode = "v";
        key = "<";
        action = "J";
      }
      {
        mode = "n";
        key = ">";
        action = "K";
      }
      {
        mode = "v";
        key = ">";
        action = "K";
      }
      {
        mode = "n";
        key = "?";
        action = "L";
      }
      {
        mode = "v";
        key = "?";
        action = "L";
      }
    ];
  };
}
