{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
in
{

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/esauder" else "/Users/esauder";
  home.username = "esauder";

  xdg.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "discord"
      "obsidian"
      "perfecto-calligraphy-pu-ttf"
      "shelley-allegro-bt-otf"
      "reaper"
      "winbox"

      # Browser plugins
      "onepassword-password-manager"
      "languagetool"
      "fakespot-fake-reviews-amazon"
      "flagfox"
    ];

  imports = [
    ./programs
    #./ui
  ];

  # -- Handle in sys config
  # prog.steam.enable = true;
  # prog.inkscape.enable = true;
  # prog.libreoffice.enable = true;
  # prog.obs.enable = true;

  prog.discord.enable = false;
  #prog.floorp.enable = true;
  prog.obsidian.enable = true;
  prog.reaper.enable = true;
  prog.spacedrive.enable = true;
  prog.ssh.enable = true;
  prog.wezterm.enable = true;
  prog.neovim.enable = true;
  prog.git = {
    enable = true;
    editor = "${config.programs.nixvim.package}/bin/nvim";
  };
  prog.fish.enable = true;
  prog.starship.enable = true;
  prog.tmux.enable = true;
  prog.zoxide.enable = true;
  prog.sesh.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.toybox
    pkgs.util-linux
    pkgs.parallel
    pkgs.rsync

    # Default dev env
    pkgs.go
    pkgs.gotools
    pkgs.dotnet-sdk_9
    pkgs.zig
    pkgs.rust-bin.stable.latest.default
  ];

  home.file = {
    ".parallel/will-cite" = {
      recursive = true;
      enable = true;
      text = "";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #programs._1password.enable = true;
  #programs._1password-gui = {
  #  enable = true;
  #  polkitPolicyOwners = [ "esauder" ];
  #};

  # home.activation.link-apps = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
  #   new_nix_apps="${config.home.homeDirectory}/Applications/Nix"
  #   rm -rf "$new_nix_apps"
  #   mkdir -p "$new_nix_apps"
  #   find -H -L "$genProfilePath/home-files/Applications" -name "*.app" -type d -print | while read app; do
  #     real_app=$(readlink -f "$app")
  #     app_name=$(basename "$app")
  #     target_app="$new_nix_apps/$app_name"
  #     echo "Alias '$real_app' to '$target_app'"
  #     ${pkgs.mkalias}/bin/mkalias "$real_app" "$target_app"
  #   done
  # '';

  # apps_source="${config.system.build.applications}/Applications"

  home.activation.addApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    apps_source="${apps}/Applications"
    moniker="Nix Trampolines"
    app_target_base="$HOME/Applications"
    app_target="$app_target_base/$moniker"
    rm -f "$app_target/*"
    mkdir -p "$app_target"
    ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
  '';
  # home.activation.addApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   echo "setting up ~/Applications/Home Manager Apps..." >&2
  #   nix_apps="$HOME/Applications/Home Manager Apps"

  #   # Delete the directory to remove old links
  #   $DRY_RUN_CMD rm -rf "$nix_apps"
  #   $DRY_RUN_CMD mkdir -p "$nix_apps"

  #   $DRY_RUN_CMD find ${apps}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  #       while read src; do
  #           # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
  #           # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
  #           # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
  #           /usr/bin/osascript -e "
  #               set fileToAlias to POSIX file \"$src\"
  #               set applicationsFolder to POSIX file \"$nix_apps\"

  #               tell application \"Finder\"
  #                   make alias file to fileToAlias at applicationsFolder
  #                   # This renames the alias; 'mpv.app alias' -> 'mpv.app'
  #                   set name of result to \"$(${pkgs.toybox}/bin/rev <<< "$src" | ${pkgs.toybox}/bin/cut -d'/' -f1 | ${pkgs.toybox}/bin/rev)\"
  #               end tell
  #               $DRY_RUN_CMD cp --archive -H --dereference ${appEnv}/Applications/* "$HM_APPS"
  #               $DRY_RUN_CMD chmod +w -R "$HM_APPS"
  #           " 1>/dev/null
  #       done
  # '';

}
