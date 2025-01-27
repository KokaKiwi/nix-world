{ config, pkgs, lib, ... }:
let
  inherit (config.lib) files tmux;
in {
  programs.tmux = {
    enable = true;

    package = pkgs.tmux.override {
      stdenv = pkgs.llvmStdenv;
    };

    terminal = "tmux-256color";
    mouse = true;
    aggressiveResize = true;
    clock24 = true;
    shortcut = "s";
    escapeTime = 0;
    historyLimit = 50000;
    baseIndex = 1;

    shell = config.home.shell.fullPath;

    updateEnvironment = [
      "SSH_AUTH_SOCK" "SSH_CONNECTION" "SSH_ASKPASS"
      "GIT_ASKPASS"
      "DISPLAY" "JAVA_HOME"
      "KITTY_INSTALLATIOn_DIR" "KITTY_LISTEN_ON" "KITTY_PID" "KITTY_PUBLIC_KEY" "KITTY_WINDOW_ID"
      "XAUTHORITY" "PINENTRY" "GTK_USE_PORTAL" "GTK_IM_MODULE" "QT_IM_MODULE"
      "XMODIFIERS" "KDE_FULL_SESSION" "KDE_SESSION_UID"
      "TERM" "TERM_PROGRAM"
    ];

    extraOptions = {
      status-right-length = toString 100;
      status-left-length = toString 120;
    };

    extraConfig = let
      baseConfig = files.readLocalConfig "tmux/tmux.conf";

      catppuccinStatusModules = lib.concatMapStrings (name: "#{E:@catppuccin_status_${name}}");

      leftModules = [ "session" ];
      rightModules = [ "load" "date_time" ];
    in ''
      ${baseConfig}

      set -g status-left "${catppuccinStatusModules leftModules} "
      set -g status-right "${catppuccinStatusModules rightModules}"
    '';
  };

  catppuccin.tmux = {
    extraConfig = tmux.formatOptions {
      prefix = "@catppuccin_";
    } {
      # Window
      window_current_number_color = "#{@thm_green}";

      window_status_style = "basic";

      window_text = " #W ";
      window_current_text = " #W ";

      # Status
      status_left_separator = " ";
      status_right_separator = "";
      status_connect_separator = "yes";

      date_time_text = " %H:%M ";
      load_text = " #(${lib.getExe pkgs.tmux-mem-cpu-load} --interval 2) ";
      session_text = " #S ";
    };
  };
}
