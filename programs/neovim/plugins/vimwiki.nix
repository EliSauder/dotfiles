{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    vimwiki = {
      enable = true;
      settings = {
        list = [
          {
            path = "~/source/wiki/";
            ext = "md";
            syntax = "markdown";
            diary_rel_path = "notes";
          }
        ];
        use_calendar = 1;
        auto_header = 1;
      };
    };
    cmp-vimwiki-tags = {
      enable = true;
    };
  };
}
