{ config, pkgs, lib, ... }:
let
  mpdCfg = config.services.mpd;
  beetsCfg = config.programs.beets;

  inherit (config) xdg;
in {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      stdenv = pkgs.llvmStdenv;
      visualizerSupport = true;
    };

    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = mpdCfg.network.port;
      mpd_music_dir = xdg.userDirs.music;

      media_library_primary_tag = "album_artist";

      user_interface = "alternative";
    };
  };

  services.mopidy = {
    enable = true;

    extensionPackages = with pkgs; [
      mopidy-local
      mopidy-mpd
    ];

    settings = {
      core = {
        restore_state = true;
      };

      file = {
        enabled = true;
        media_dirs = [
          "$XDG_MUSIC_DIR|${xdg.userDirs.music}"
        ];
        follow_symlinks = true;
        excluded_file_extensions = [
          ".directory"
          ".html"
          ".jpeg"
          ".jpg"
          ".log"
          ".nfo"
          ".pdf"
          ".png"
          ".txt"
          ".zip"
        ];
      };

      local = {
        enabled = true;
        media_dir = xdg.userDirs.music;
      };

      mpd = {
        enabled = true;
        port = mpdCfg.network.port;
      };
    };
  };

  programs.beets = {
    enable = true;
    package = pkgs.beetsPackages.beets-minimal.override {
      pluginOverrides = {
        chroma.enable = true;
        convert.enable = true;
        fetchart.enable = true;
        fromfilename.enable = true;
        info.enable = true;
        ipfs.enable = true;
        lastgenre.enable = true;
        mbsync.enable = true;
        thumbnails.enable = true;
      };
    };

    settings = {
      asciify_paths = true;

      import = {
        resume = true;
        languages = "en jp";
        group_albums = true;
      };

      convert = {
        copy_album_art = true;
        dest = "${xdg.userDirs.music}";
        embed = false;
        format = "ogg";
      };

      ui = {
        terminal_width = 120;
      };

      plugins = let
        enabledPlugins = lib.filterAttrs (_: p: p.enable) beetsCfg.package.plugins;
      in lib.attrNames enabledPlugins;
    };

    mpdIntegration = {
      enableStats = true;
      enableUpdate = true;

      host = "127.0.0.1";
      port = mpdCfg.network.port;
    };
  };
}
