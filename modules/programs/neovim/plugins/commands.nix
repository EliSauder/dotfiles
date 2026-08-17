{ ... }:
{

  programs.nixvim.userCommands = {
    "GoBazelSync".command.__raw = ''
      function()
        vim.notify("Running Go/Bazel sync...", vim.log.levels.INFO)
        vim.system(
          { "bash", "-lc", "go mod tidy && bazel run //:gazelle && bazel mod tidy" },
          {test = true},
          function(result)
            vim.schedule(function()
              if result.code ~= 0 then
                vim.notify("Go/Bazel sync failed:\n" .. (result.stderr or result.stdout or ""), vim.log.levels.ERROR)
                return
              end

              vim.notify("Go/Bazel sync complete; restarting gopls", vim.log.levels.INFO)

              found = false
              for _, client in ipairs(vim.lsp.get_clients({ name = "gopls" })) do
                found = true
              end
              if found then
                vim.cmd("lsp restart gopls")
              end
            end)
          end
        )
      end
    '';
  };
}
#
#for _, client in ipairs(vim.lsp.get_clients({ name = "gopls" })) do
#  client:stop(2000)
#end
