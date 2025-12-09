{ ... }:
{
  programs.nixvim.plugins = {
    friendly-snippets = {
      enable = true;
    };
    mini = {
      enable = true;
      autoLoad = true;
      modules = {
        snippets = {
          snippets = [
            {
              __raw = "require('mini.snippets').gen_loader.from_lang()";
            }
          ];
        };
      };
    };
  };
}
