{ config, ... }:
{
  programs.pgcli = {
    enable = true;
    settings = config.lib.files.localConfigPath "pgcli/config";
  };
}
