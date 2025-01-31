{ config, lib, secretsPath, ... }:
{
  options = with lib; {
    name = mkOption {
      type = types.str;
    };

    useLix = mkOption {
      type = types.bool;
      default = false;
    };

    secrets = {
      file = mkOption {
        type = types.nullOr types.path;
        default = let
          secretPath = "${secretsPath}/${config.name}.yml";
        in if lib.pathExists secretPath then secretPath else null;
      };
    };
  };
}
