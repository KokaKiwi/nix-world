{ ... }:
let
  sources = import ./sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      (import "${sources.lix.nixos-module}/overlay.nix" {
        inherit (sources.lix) lix;
      })
      (self: super: import ./pkgs {
        pkgs = self;
        inherit super sources;
      })
    ];
  };
  inherit (pkgs) lib;

  mkWorld = hosts: let
    evalHost = name: host: lib.evalModules {
      class = "nix-world";

      modules = [
        ./modules/world
        {
          name = lib.mkDefault name;
        }
        host
      ];

      specialArgs = {
        inherit pkgs sources;
        lib = lib.extend (self: super: {
          world = import ./lib self;
        });

        hosts = hostModules;

        modulesPath = ./modules;
        pkgsPath = ./pkgs;
        secretsPath = ./secrets;
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
in {
  hosts = mkWorld (import ./hosts);

  inherit sources;
  inherit pkgs lib;
}
