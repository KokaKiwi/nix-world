{ config, lib, sources, pkgsPath, ... }:
let
  cfg = config.nixpkgs;

  nixosVersions = let
    nixosChannels = lib.filter (lib.hasPrefix "nixos-") (lib.attrNames sources);
  in map (lib.removePrefix "nixos-") nixosChannels;

  overlayType = lib.mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };
in {
  options.nixpkgs = with lib; {
    config = mkOption {
      type = types.attrs;
      default = { };
    };
    overlays = mkOption {
      type = types.listOf overlayType;
      default = [ ];
    };

    version = mkOption {
      type = types.enum (nixosVersions ++ [ "unstable" ]);
      default = "unstable";
    };
    path = mkOption {
      type = types.path;
    };

    pkgs = mkOption {
      type = types.pkgs;
      readOnly = true;
      internal = true;
    };
  };

  config = {
    nixpkgs.path = let
      path = if cfg.version == "unstable"
      then sources.nixpkgs
      else sources."nixos-${cfg.version}";
    in lib.mkDefault path;

    nixpkgs.overlays = [
      (self: super: import pkgsPath {
        pkgs = self;
        inherit super sources;
      })
    ];

    nixpkgs.pkgs = import cfg.path {
      overlays = [
        ((import sources.nix-vscode-extensions).overlays.default)
      ]
      ++ lib.optional config.useLix (import "${sources.lix.nixos-module}/overlay.nix" {
        inherit (sources.lix) lix;
      })
      ++ cfg.overlays;

      inherit (cfg) config;
    };
  };
}
