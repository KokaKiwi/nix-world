{ config, lib, ... }:
let
  cfg = config.cluster.ssh;
in {
  users.users = lib.mapAttrs (name: user: {
    openssh.authorizedKeys.keys = user.keys;
  }) cfg.users;
}
