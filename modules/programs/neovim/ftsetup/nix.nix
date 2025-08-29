{pkgs, ...}: {
  programs.nixvim.autoCmd = [
    {
      event = "FileType";
      pattern = [
        "nix"
        "flake"
      ];
      callback.__raw = ''
        function()
            vim.o.tabstop = 2;
            vim.o.shiftwidth = 2;
        end
      '';
    }
  ];
}
