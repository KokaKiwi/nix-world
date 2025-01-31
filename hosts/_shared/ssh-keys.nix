{ config, lib, ... }:
let
  cfg = config.shared.ssh-keys;
in {
  options.shared.ssh-keys = with lib; {
    keys = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    users = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };

  config = {
    shared.ssh-keys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPTsEgcOtb2bij+Ih8eg8ZqO7d3IMiWykv6deMzlSSS kokakiwi@kira"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNHZAeTfsDjafr929GH94NJYw2hY4d6vtIUWFD0EBDU cardno:000F_3F430F51"
    ];

    users.users = lib.listToAttrs (lib.map (username: lib.nameValuePair username {
      openssh.authorizedKeys.keys = cfg.keys;
    }) cfg.users);
  };
}
