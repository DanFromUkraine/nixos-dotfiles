{ powerProfile, pkgs }:
let
  searxWebEngines = [
    "bing"
    "yahoo"
    "mwmbl"
    "wiby"
  ];

  searxSiteEngines = [
    "gitlab"
    "codeberg"
    "gitea.com"
    "bitbucket"
    "sourcehut"
    "huggingface"
    "huggingface datasets"
    "huggingface spaces"
    "mdn"
    "microsoft learn"
    "nixos wiki"
    "free software directory"
    "mankier"
    "docker hub"
    "anaconda"
    "npm"
    "pypi"
    "crates.io"
    "hex"
    "lib.rs"
    "pkg.go.dev"
    "packagist"
    "rubygems"
    "metacpan"
    "pub.dev"
    "hoogle"
    "alpine linux packages"
    "cachy os packages"
    "voidlinux"
    "apk mirror"
    "fdroid"
    "apple app store"
    "google play apps"
    "arch linux wiki"
    "gentoo"
    "national vulnerability database"
    "hackernews"
    "lobste.rs"
    "habrahabr"
    "stackoverflow"
    "askubuntu"
    "superuser"
    "discuss.python"
    "caddy.community"
    "pi-hole.community"
    "minecraft wiki"
    "arxiv"
    "crossref"
    "openalex"
    "semantic scholar"
    "google scholar"
    "openairepublications"
    "openairedatasets"
    "pdbe"
    "wikipedia"
    "wikidata"
    "wikinews"
    "wiktionary"
  ];

  searxWikiEngines = [
    "wikibooks"
    "wikiquote"
    "wikisource"
    "wikispecies"
    "wikiversity"
    "wikivoyage"
  ];

  searxDisabledEngines = [
    "pubmed"
    "europepmc"
  ];

  searxEngineEntry = disabled: name: {
    inherit name disabled;
  };

  searxWikiEngineEntry = name: {
    inherit name;
    disabled = false;
    categories = [ "wikimedia" ];
  };
in
{
  udev.packages = [ pkgs.brightnessctl ];

  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  pulseaudio.enable = false;

  displayManager = {
    noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "niri";
        user.default = "linkava";
        appearance.scheme = "Noctalia";
        keyboard.layout = "us";
        clock.enabled = true;
      };
    };
    defaultSession = "niri";
  };

  clamav = {
    updater.enable = true;
  };

  tor = {
    enable = true;
    enableGeoIP = true;

    client.enable = true;
  };

  system76-scheduler.enable = true;

  scx-loader = {
    enable = true;
    config.default_sched = "scx_flash";
  };
  hide-me = {
    enable = false;
    server = "free-us";
  };

  searx = {
    enable = true;
    environmentFile = "/home/linkava/nixos-config/secrets/apis/.searxng.env";
    settings = {
      general = {
        debug = false;
      };
      server = {
        bind_address = "127.0.0.1";
        port = 2202;
      };
      search = {
        formats = [
          "html"
          "json"
        ];
        autocomplete = "";
      };
      preferences.lock = [ "autocomplete" ];
      engines =
        map (searxEngineEntry false) (searxWebEngines ++ searxSiteEngines)
        ++ map searxWikiEngineEntry searxWikiEngines
        ++ map (searxEngineEntry true) searxDisabledEngines;
      outgoing = {
        proxies."all://" = [ "$SEARX_PROXY" ];
        request_timeout = 15.0;
        max_request_timeout = 30.0;
        extra_proxy_timeout = 12;
      };
    };
  };
}
