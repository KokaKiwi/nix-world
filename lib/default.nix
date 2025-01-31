{ pkgs, sources }:
let
  inherit (pkgs) lib;
in {
  mkWorld = hosts: let
    evalHost = name: host: lib.evalModules {
      class = "nix-world";

      modules = [
        ../modules/world
        {
          name = lib.mkDefault name;
        }
        host
      ];

      specialArgs = {
        inherit pkgs sources;
        lib = lib.extend (self: super: {
          world = import ./world self;
        });
        hosts = hostModules;

        modulesPath = ../modules;
        pkgsPath = ../pkgs;
        secretsPath = ../secrets;
      };
    };

    hostModules = lib.mapAttrs evalHost hosts;
    hostPackages = lib.mapAttrs (name: module: module.config.package // {
      inherit module;
      inherit (module) config;
    }) hostModules;
  in pkgs.linkFarm "world" hostPackages // hostPackages // {
    hosts = hostModules;
  };
}
