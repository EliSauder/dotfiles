{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.gitws;
  package = (
    pkgs.git-worktree-switcher.overrideAttrs (
      finalAttrs: previousAtts: {
        pname = "git-worktree-switcher-patch";
        version = "0.2.5";
        src = pkgs.fetchFromGitHub {
          owner = "EliSauder";
          repo = "git-worktree-switcher";
          rev = "a90315c8637e32377abdf6230240e72a8e5471e8";
          tag = null;
          hash = "sha256-XMrdnbsk+N1CHpb8WzN/61uZtb1elPU829EuShRil74=";
        };
      }
    )
  );

  initScript =
    shell:
    if (shell == "fish") then
      ''
        ${lib.getExe package} init ${shell} | source
      ''
    else
      ''
        eval "$(${lib.getExe package} init ${shell})"
      '';
in
{
  options.prog = {
    gitws.enable = lib.mkEnableOption "Enable git worktree switcher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      package
    ];

    programs.bash.initExtra = initScript "bash";
    programs.fish.interactiveShellInit = initScript "fish";
    programs.zsh.initContent = initScript "zsh";
  };
}
