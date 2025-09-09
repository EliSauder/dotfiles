{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.qutebrowser;
in
{
  options.prog = {
    qutebrowser.enable = lib.mkEnableOption "Enable firefox";
    qutebrowser.package = lib.mkPackageOption pkgs "qutebrowser" {
      example = "qutebrowser";
    };
    qutebrowser.guiVimEditor = lib.mkOption {
      default = "ghostty --command fish -c nvim";
    };
    qutebrowser.setDefault = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = lib.mkIf cfg.setDefault {
      "x-www-browser" = [ "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop" ];
      "gnome-www-browser" = [
        "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop"
      ];
      "default-web-browser" = [
        "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop"
      ];
      "text/html" = [ "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop" ];
      "x-scheme-handler/http" = [
        "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop"
      ];
      "x-scheme-handler/https" = [
        "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop"
      ];
      "x-scheme-handler/about" = [
        "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop"
      ];
      "x-scheme-handler/unknown" = [
        "${pkgs.qutebrowser}/share/applications/org.qutebrowser.qutebrowser.desktop"
      ];
    };

    catppuccin.qutebrowser = {
      enable = true;
    };

    programs.qutebrowser = {
      enable = true;
      package = cfg.package.overrideAttrs (
        final: prev: {
          buildInputs = prev.buildInputs ++ [
            pkgs.python313Packages.pyu2f
            pkgs.python313Packages.pyfido
            pkgs.python313Packages.fido2
          ];
        }
      );
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
        nhm = "https://home-manager-options.extranix.com/?query={}";
        np = "https://search.nixos.org/packages?query={}";
        no = "https://search.nixos.org/options?query={}";
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      };

      settings = {
        auto_save.session = true;

        colors.webpage = {
          preferred_color_scheme = "dark";
          darkmode = {
            enabled = true;
            algorithm = "lightness-cielab";
            policy.images = "never";
          };
        };

        editor = {
          command = [
            cfg.guiVimEditor
            "-f"
            "{file}"
            "-c"
            "normal {line}G{column0}l"
          ];
        };

        hints = {
          chars = "arstdoienh";
        };

        input = {
          insert_mode = {
            auto_load = true;
          };
          spatial_navigation = true;
        };

        #url = {
        #  start_pages = [
        #    "file:/${pkgs.catppuccin-startpage}/index.html"
        #  ];
        #};

        keyhint.delay = 200;

        new_instance_open_target = "tab-bg-silent";

        scrolling.smooth = true;

        spellcheck.languages = [
          "en-US"
        ];

        content = {
          pdfjs = true;
          default_encoding = "utf-8";
          hyperlink_auditing = true;
          blocking = {
            enabled = true;
            method = "both";
          };
        };
      };

      extraConfig = ''
        config.set('colors.webpage.darkmode.enabled', False, 'file://*')
        c.tabs.padding = {'top': 5, 'bottom': 5, 'left': 9, 'right': 9}
      '';

      keyBindings = {
        normal = {
          "h" = "history";
        };
      };

      greasemonkey = [
        (pkgs.writeText "yt-ads.js" ''
          // ==UserScript==
          // @name         Auto Skip YouTube Ads 
          // @version      1.0.1
          // @description  Speed up and skip YouTube ads automatically 
          // @author       jso8910
          // @match        *://*.youtube.com/*
          // ==/UserScript==

          document.addEventListener('load', () => {
            try { document.querySelector('.ad-showing video').currentTime = 99999 } catch {}
            try { document.querySelector('.ytp-ad-skip-button').click() } catch {}
            try { document.querySelector('.ytp-skip-ad-button').click() } catch {}
            try { document.querySelector('.videoAdUiSkipButton').click() } catch {}
          }, true);

          let main = new MutationObserver(() => {
              let ad = [...document.querySelectorAll('.ad-showing')][0];
              if (ad) {
                  let btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button')
                  if (btn) {
                      btn.click()
                  }
              }
          })

          main.observe(document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button,.ytp-skip-ad-button'), {attributes: true, characterData: true, childList: true})
        '')
      ];
    };
  };
}
