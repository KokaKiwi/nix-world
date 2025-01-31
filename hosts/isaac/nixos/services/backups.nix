{ config, pkgs, ... }:
let
  inherit (config.lib) secrets;

  repo = "ssh://zh1779@zh1779.rsync.net/./isaac";

  borg-wrapper = pkgs.writeShellScriptBin "borg-rsync" ''
    export BORG_RSH="ssh -i ${secrets.path "ssh_rsync_ed25519_key"}"
    export BORG_REPO="${repo}";
    export BORG_PASSCOMMAND="cat ${secrets.path "borg-repo-password"}"

    exec ${pkgs.borgbackup}/bin/borg "$@"
  '';
in {
  services.borgbackup.jobs = let
    mkBackupJob = name: args: {
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${secrets.path "borg-repo-password"}";
      };

      environment.BORG_RSH = "ssh -i ${secrets.path "ssh_rsync_ed25519_key"}";

      inherit repo;
      archiveBaseName = name;

      compression = "auto,zstd";
    } // args;
  in {
    gotosocial-db = mkBackupJob "gotosocial-db" {
      startAt = "daily";

      dumpCommand = pkgs.writeShellScript "dump-gotosocial-db" ''
        ${pkgs.sudo}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/pg_dump -C gotosocial
      '';
    };
  };

  secrets = {
    "borg-repo-password" = { };
    "ssh_rsync_ed25519_key" = { };
  };

  environment.systemPackages = [ borg-wrapper ];
}
