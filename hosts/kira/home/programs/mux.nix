{ config, pkgs, ... }:
let
  tmuxCfg = config.programs.tmux;
in {
  programs.mux = {
    enable = true;
    package = pkgs.mux.override {
      tmux = tmuxCfg.package;
    };
  };
}
