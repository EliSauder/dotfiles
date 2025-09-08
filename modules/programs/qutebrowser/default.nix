{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.qutebrowser;
  isLinux = pkgs.stdenv.isLinux;
  pkg =
    if isLinux then
      pkgs.firefox.override {
        nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
      }
    else
      pkgs.firefox;
in
{
  options.prog = {
    qutebrowser.enable = lib.mkEnableOption "Enable firefox";
    mpd.package = lib.mkPackageOption pkgs "qutebrowser" { example = "qutebrowser"; };
    qutebrowser.setDefault = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = lib.mkIf cfg.setdefault {
      #"x-www-browser" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"gnome-www-browser" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"default-web-browser" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"text/html" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"x-scheme-handler/http" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"x-scheme-handler/https" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"x-scheme-handler/about" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
      #"x-scheme-handler/unknown" = [ "${pkgs.firefox}/share/applications/firefox.desktop" ];
    };

    programs.qutebrowser = {
      enable = true;
      package = cfg.package;
      quickmarks = {
        wt = "https://teams.microsoft.com/v2";
        wo = "https://outlook.office.com/mail";
        wc = "https://hmelectronics.sharepoint.com/Pages/default.aspx";
        wu = "https://hmeukg.ukg.net";
        ws = "https://servicedesk.hme.com/home";
        gh = "https://github.com";
        yt = "https://www.youtube.com";
      };
      searchEngines = {
        g = "https://www.google.com/search?udm=14&q={}";
        d = "https://duckduckgo.com/?q={}";
      };
    };
  };
}
