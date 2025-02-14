{ config, pkgs, ... }:
let
  cfg = config.programs.yazi;
  batCfg = config.programs.bat;

  bat-yazi = pkgs.writeShellScriptBin "bat-yazi" ''
    export EDITOR="${batCfg.package}/bin/bat --pager=${pkgs.less}/bin/less --paging=always"
    exec ${cfg.package}/bin/yazi "$@"
  '';
in {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      manager = {
        sort_dir_first = true;
      };
    };
  };

  home.packages = [ bat-yazi ];
}
