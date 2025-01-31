{ pkgs, ... }:
{
  services.postgresql = {
    package = pkgs.postgresql_15;
    enableJIT = true;
    extensions = ps: with ps; [ pg_repack ];
  };
}
