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
      config = mkOption {
        type = types.attrs;
        default = { };
      };
      overlays = mkOption {
        type = types.listOf overlayType;
        default = [ ];
      };

      version = mkOption {
        type = types.enum ((map (lib.removePrefix "nixos-") nixosChannels) ++ [ "unstable" ]);
        default = "unstable";
      };
      path = mkOption {
        type = types.path;
      };
    };

    useLix = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    nixpkgs.path = let
      path = if config.nixpkgs.version == "unstable"
      then sources.nixpkgs
      else sources."nixos-${config.nixpkgs.version}";
    in lib.mkDefault path;

    nixpkgs.overlays = [
      (self: super: import pkgsPath {
        pkgs = self;
        inherit super sources;
      })
    ];
  };
}
