{...}: {
  programs.nixvim.keymapsOnEvents = {
    LspAttach = [
      {
        mode = "n";
        key = "gd";
        action = ":lua vim.lsp.buf.definition()<cr>";
        options = {silent = true;};
      }
      {
        mode = ["n" "i"];
        key = "<C-h>";
        action = ":lua vim.lsp.buf.hover()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<leader>vca";
        action = ":lua vim.lsp.buf.code_action()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<leader>vrr";
        action = ":lua vim.lsp.buf.references()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<leader>vrn";
        action = ":lua vim.lsp.buf.rename()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<leader>vd";
        action = ":lua vim.diagnostic.open_float()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<leader>qf";
        action = ":lua vim.lsp.buf.code_action({ filter = function(a) return a.isPreferred end, apply = true })<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<C-,>";
        action = ":lua vim.diagnostic.goto_next()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "<C-.>";
        action = ":lua vim.diagnostic.goto_prev()<cr>";
        options = {silent = true;};
      }
      {
        mode = "n";
        key = "gh";
        action.__raw = ''
          function()
            if client ~= nil and client.name == "clangd" then
                vim.cmd(":ClangdSwitchSourceHeader<cr>")
            end
          end
        '';
        options = {silent = true;};
      }
    ];
  };
}
