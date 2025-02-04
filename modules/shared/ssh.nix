{ config, lib, ... }:
let
  cfg = config.cluster.ssh;
in {
  options.cluster.ssh = with lib; {
    keys = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    users = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          keys = mkOption {
            type = types.listOf types.str;
            default = cfg.keys;
          };
        };
      });
      default = { };
    };
  };
}
