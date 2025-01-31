{ ... }:
{
  services.borgbackup.jobs = let
    backupJob = {
      name,
      ...
    }@args: builtins.removeAttrs args [ "name" ] // {
      encryption.mode = "none";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      repo = "file:///var/data/backups/${name}";
      compression = "zstd,1";
      startAt = "daily";
      readWritePaths = [
        "/var/data/backups"
      ];
    };
  in {
    data = backupJob {
      name = "data";
      paths = "/var/lib";
      exclude = [
        "/var/lib/containers/storage/overlay"
      ];
    };
  };
}
