{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.mux;
in {
  options.programs.mux = {
    enable = mkEnableOption "mux";

    package = mkPackageOption pkgs "mux" {};
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.fish.completions.mux = ''
      ${getExe cfg.package} completions fish | source

      # Complete sessions
      function __fish_mux_complete_sessions
        ${getExe cfg.package} list | awk '{ print $2; }' | sort -u
      end

      for cmd in dump delete edit load
        complete -c mux -n "__fish_seen_subcommand_from $cmd" -f -a '(__fish_mux_complete_sessions)'
      end
    '';
  };
}
