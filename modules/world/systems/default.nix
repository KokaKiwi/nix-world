{ config, lib, sources, ... } @ topArgs:
let
  hostConfig = config;

  builders = {
    home-manager = import ./home-manager.nix;
    system-manager = import ./system-manager.nix;
  };

  systemType = with lib; types.submodule ({ name, config, options, ... }: let
    nixpkgs = import hostConfig.nixpkgs.path {
      overlays = [
        ((import sources.nix-vscode-extensions).overlays.default)
      ]
      ++ lib.optional hostConfig.useLix (import "${sources.lix.nixos-module}/overlay.nix" {
        inherit (sources.lix) lix;
      })
      ++ hostConfig.nixpkgs.overlays;

      inherit (hostConfig.nixpkgs) config;
    };

    systemConfig = removeAttrs config (lib.attrNames options);
    system = builders.${config.builder} (topArgs // systemConfig // {
      inherit (config) name;

      inherit nixpkgs;
    });
  in {
    freeformType = types.attrs;

    options = {
      builder = mkOption {
        type = types.str;
      };
      name = mkOption {
        type = types.str;
        default = name;
      };

      system = mkOption {
        type = types.submodule ({ config, ... }: {
          freeformType = types.attrs;

          options = {
            package = mkOption {
              type = types.package;
              readOnly = true;
            };
            activate = mkOption {
              type = types.path;
              default = "${config.package}/${config.package.activationPath}";
            };

            packages = mkOption {
              type = types.listOf types.package;
              default = [ ];
            };

            pathsToCache = mkOption {
              type = types.listOf types.path;
              default = [ ];
            };
          };
        });
        readOnly = true;
        internal = true;
      };
    };

    config = {
      inherit system;
    };
  });
in {
  options.systems = with lib; mkOption {
    type = types.attrsOf systemType;
    default = { };
  };
}
