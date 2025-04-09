{pkgs, ...}: {
  programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        completion.accept.auto_brackets.semantic_token_resolution.enabled =
          true;
      };
    };
  };
}
