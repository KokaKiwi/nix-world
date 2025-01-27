{ config, lib, sources, pkgsPath, ... }:
let
  nixosChannels = lib.filter (lib.hasPrefix "nixos-") (lib.attrNames sources);

  overlayType = lib.mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };
in {
  options = with lib; {
    name = mkOption {
      type = types.str;
    };

    nixpkgs = {
      path = mkOption {
        type = types.path;
      };
      config = mkOption {
        type = types.attrs;
        default = { };
      };
      overlays = mkOption {
        type = types.listOf overlayType;
        default = [ ];
      };

      channel = mkOption {
        type = types.enum (nixosChannels ++ [ "nixpkgs-unstable" ]);
        default = "nixpkgs-unstable";
      };
    };

    useLix = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    nixpkgs.path = let
      path = if config.nixpkgs.channel == "nixpkgs-unstable"
      then sources.nixpkgs
      else sources.${config.nixpkgs.channel};
    in lib.mkDefault path;

    nixpkgs.overlays = [
      (self: super: import pkgsPath {
        pkgs = self;
        inherit super sources;
      })
    ];
  };
}
