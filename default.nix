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
  lib = import ./lib {
    inherit pkgs sources;
  };
in {
  hosts = lib.mkWorld (import ./hosts);

  inherit sources;
  inherit (pkgs) pkgs lib;
  worldLib = lib;
}
