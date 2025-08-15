{ pkgs, ... }:
{
  home.packages = [
    pkgs.python313Packages.pylatexenc
  ];

  programs.nixvim.plugins = {
    transparent = {
      enable = true;
      settings = {
        extra_groups = [
          "BufferLineTabClose"
          "BufferLineBufferSelected"
          "BufferLineFill"
          "BufferLineBackground"
          "BufferLineSeparator"
          "BufferLineIndicatorSelected"
          "NormalFloat"
          "TelescopeNormal"
          "TelescopeBorder"
          "TelescopeTitle"
        ];
        groups = [
          "Normal"
          "NormalNC"
          "Comment"
          "Constant"
          "Special"
          "Identifier"
          "Statement"
          "PreProc"
          "Type"
          "Underlined"
          "Todo"
          "String"
          "Function"
          "Conditional"
          "Repeat"
          "Operator"
          "Structure"
          "LineNr"
          "NonText"
          "SignColumn"
          "CursorLine"
          "CursorLineNr"
          "StatusLine"
          "StatusLineNC"
          "EndOfBuffer"
        ];
      };
    };
    mini = {
      enable = true;
      autoLoad = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        statusline = {
          use_icons = true;
        };
      };
    };

    render-markdown = {
      enable = true;
      settings = {
        completions.lsp.enable = true;
        render_modes = true;
        signs.enabled = true;
      };
    };
  };
}
