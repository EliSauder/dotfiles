{ config, pkgs, lib, inputs, ...}: 
let
    cfg = config.prog.floorp;
in {
    options.prog = {
        floorp.enable = lib.mkEnableOption "Enable floorp";
    };

    config = lib.mkIf cfg.enable {
        programs.floorp = {
            enable = true;
            enableGnomeExtensions = true;
            languagePacks = [
                "en-US"
                "jp-JP"
            ];
            nativeMessagingHosts = [
                pkgs.tridactyl-native               
                pkgs.gnome-browser-connector
            ];
            profiles = {
                personal = {
                    id = 0;
                    path = if pkgs.stdenv.isDarwin then
                        "${config.home.homeDirectory}/Library/Application Support/Floorp"
                        else
                            "${config.home.homeDirectory}/.floorp";

                    isDefault = true;
                    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                        ublock-origin
                        noscript
                        clearurls
                        duckduckgo-privacy-essentials
                        add-custom-search-engine
                        canvasblocker
                        don-t-fuck-with-paste
                        consent-o-matic
                        istilldontcareaboutcookies

                        github-file-icons
                        github-isometric-contributions
                        octolinker
                        octotree

                        onepassword-password-manager
                        languagetool
                        fakespot-fake-reviews-amazon
                        flagfox
                        modrinthify
                        twitch-auto-points
                        youtube-shorts-block
                        zotero-connector
                    ];

                    settings = {
                        # Tabsleep
                        "floorp.tabsleep.enabled" = true;
                        "floorp.tabsleep.tabTimeoutMinutes" = 30;

                        # Tabs
                        "floorp.browser.tabs.verticaltab.enabled" = false;
                        "floorp.tabbar.style" = 0;
                        "floorp.browser.tabbar.settings" = 4;
                        "floorp.browser.sidebae.is.displayed" = 2;
                        "floorp.browser.tabs.verticaltab" = false;
                        "floorp.verticaltab.hover.enabled" = false;
                        "floorp.verticaltab.show.newtab.button" = false;

                        # Sidebar
                        "floorp.browser.sidebar.enable" = true;
                        "floorp.browser.sidebar.is.displayed" = true;
                        "floorp.browser.sidebar.right" = true;

                        # General
                        "browser.startup.homepage" = "about:blank";
                        "app.update.auto" = true;
                        "general.smoothScroll" = true;
                        "media.autoplay.default" = 1;
                        "browser.cache.disk.enable" = false;
                        "broswer.cache.memory.enable" = true;

                        # Search
                        "browser.search.region" = "US";
                        "browser.search.countryCode" = "US";
                        "browser.search.isUS" = true;

                        "extensions.pocket.enable" = false;
                        "extensions.pocket.showHome" = false;
                        
                        # Privacy
                        "privacy.trackingprotection.enabled" = true;
                        "privacy.trackingprotection.socialtracking.enabled" = true;
                        "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
                        "browser.contentblocking.category" = "strict";
                        "privacy.globalprivacycontrol.enabled" = true;

                        # Telemetry
                        "toolkit.telemetry.enabled" = false;
                        "toolkit.telemetry.server" = "data:,";
                        "toolkit.telemetry.archive.enabled" = false;
                        "toolkit.telemetry.newProfilePing.enabled" = false;
                        "toolkit.telemetry.shutdownPingSender.enabled" = false;
                        "toolkit.telemetry.updatePing.enabled" = false;
                        "toolkit.telemetry.bhrPing.enabled" = false;
                        "toolkit.telemetry.firstShutdownPing.enabled" = false;
                        "toolkit.telemetry.coverage.opt-out" = true;
                        "toolkit.coverage.opt-out" = true;
                        "toolkit.coverage.endpoint.base" = "";
                        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                        "browser.newtabpage.activity-stream.telemetry" = false;

                        "app.shield.optoutstudies.enabled" = false;
                        "app.normandy.enabled" = false;
                        "app.normandy.api_url" = "";
                        "breakpad.reportURL" = "";
                        "browser.tabs.crashReporting.sendReport" = false;
                        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
                        "captivedetect.canonicalURL" = "";
                        "network.captive-portal-service.enabled" = false;
                        "network.connectivity-service.enabled" = false;
                    };
                };
            };
        };
    };
} 
