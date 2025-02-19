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

  mkWorld = configuration: let
    module = lib.evalModules {
      class = "nix-world";

      modules = [
        ./modules/world
        configuration
      ];

      specialArgs = {
        inherit pkgs sources;
        lib = lib.extend (self: super: {
          world = import ./lib self;
        });

        modulesPath = ./modules;
        pkgsPath = ./pkgs;
        secretsPath = ./secrets;
      };
    };
  in module.config.package // {
    inherit module;
    inherit (module) config;

    inherit sources;
    inherit pkgs lib;
  };
in mkWorld {
  hosts = import ./hosts;
}
