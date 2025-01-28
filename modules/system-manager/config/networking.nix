{ config, lib, ... }:
let
  cfg = config.networking;
in {
  options.networking = with lib; {
    hosts = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      example = literalExpression ''
        {
          "127.0.0.1" = [ "foo.bar.baz" ];
          "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
        };
      '';
      description = ''
        Locally defined maps of hostnames to IP addresses.
      '';
    };
  };

  config = {
    environment.etc.hosts.text = ''
      127.0.0.1 localhost
      ::1 localhost

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (ip: hosts: "${ip} ${lib.concatStringsSep " " hosts}") cfg.hosts)}
    '';
  };
}
