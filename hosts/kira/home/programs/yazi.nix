{ config, pkgs, ... }:
let
  cfg = config.programs.yazi;
  batCfg = config.programs.bat;

  bat-yazi = let
    pager = pkgs.writeShellScript "less" ''
      exec ${pkgs.less}/bin/less -R "$@"
    '';
  in pkgs.writeShellScriptBin "bat-yazi" ''
    export EDITOR="${batCfg.package}/bin/bat --pager=${pager} --paging=always"
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
