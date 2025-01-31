{ config, lib, ... }:
let
  cfg = config.deployment;
in {
  options.deployment = with lib; {
    targetHost = mkOption {
      type = types.str;
      default = config.networking.hostName;
    };
    targetPort = mkOption {
      type = types.nullOr types.port;
      default = null;
    };
    targetUser = mkOption {
      type = types.str;
      default = "root";
    };

    sshOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = {
    deployment.sshOptions =
      lib.optionals (cfg.targetPort != null) [ "-p" (toString cfg.targetPort) ];
  };
}
