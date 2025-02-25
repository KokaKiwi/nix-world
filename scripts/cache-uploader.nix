{ config, pkgs, lib, ... }:
let
  paths = lib.flatten (lib.mapAttrsToList (_: host:
    lib.flatten (lib.mapAttrsToList (_: system:
      system.pathsToCache
    ) host.systems)
  ) config.hosts);
in ''
  ${pkgs.attic-client}/bin/attic push kokakiwi ${toString paths}
''
