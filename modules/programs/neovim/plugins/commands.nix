{ ... }:
{

  programs.nixvim.userCommands = {
    "GoBazelSync".command.__raw = ''
      vim.system(
        { "bash", "-lc" "go mod tidy && bazel run //:gazelle"},
        {test = true},
        function(result)
          vim.schedule(function()
            if result.code ~= 0 then
              vim.notify("Go/Bazel sync failed:\n" .. (result.stderr or result.stdout or ""), vim.log.levels.ERROR)
              return
            end

            vim.notify("Go/Bazel sync complete; restarting gopls", vim.log.levels.INFO)

            for _, client in ipairs(vim.lsp.get_clients({ name = "gopls" })) do
              client.stop(true)
            end
            vim.defer_fn(function()
              vim.cmd("edit")
            end, 100)
          end)
        end
      )
    '';
  };
}
