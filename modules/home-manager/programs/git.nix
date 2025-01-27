{ config, lib, ... }:
let
  cfg = config.programs.git;
in {
  options.programs.git = with lib; {
    pathConfigs = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
    };
  };

  config.programs.git = with lib; mkIf cfg.enable {
    includes = mapAttrsToList (path: config: {
      condition = "gitdir:${path}";
      contents = config;
    }) cfg.pathConfigs;
  };
}
