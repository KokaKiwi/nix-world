{ config, lib, ... }:
with lib;
let
  cfg = config.programs.ssh;
in {
  options = {
    programs.ssh = {
      authorizedKeys = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    home.file.".ssh/authorized_keys" = mkIf (cfg.authorizedKeys != []) {
      text = (concatMapStrings (key: "${key}\n") cfg.authorizedKeys);
    };
  };
}
