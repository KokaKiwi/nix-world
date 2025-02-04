{ config, lib, hosts, sources, modulesPath, ... }:
let
  cfg = config.home;

  inherit (config) nixpkgs;

  module = import "${cfg.source}/modules" {
    inherit (nixpkgs) pkgs;
    check = true;

    configuration = { lib, ... }: {
      imports = [
        (modulesPath + "/home-manager")
        (modulesPath + "/shared")
        cfg.configuration
      ]
      ++ lib.optional (config.secrets.file != null) {
        imports = [
          "${sources.sops-nix}/modules/home-manager/sops.nix"
        ];

        sops.defaultSopsFile = config.secrets.file;
      }
      ++ nixpkgs.pkgs.nur.repos.kokakiwi.modules.home-manager.all-modules;

      _module.args = {
        pkgs = lib.mkForce nixpkgs.pkgs;
      };
    };

    extraSpecialArgs = cfg.extraSpecialArgs // {
      inherit hosts sources;
    };
  };

  env = {
    inherit module;
    inherit (module) config options pkgs;
    inherit (module.pkgs) lib;
  } // module.config.env;
in {
  options.home = with lib; {
    configuration = mkOption {
      type = types.nullOr world.types.nixConfiguration;
      default = null;
    };
    extraSpecialArgs = mkOption {
      type = types.attrs;
      default = { };
    };

    source = mkOption {
      type = types.anything;
      readOnly = true;
      internal = true;
    };
  };

  config = {
    home.source = if config.nixpkgs.version == "unstable"
      then sources.home-manager
      else sources."home-manager-${config.nixpkgs.version}";

    systems.home = lib.mkIf (cfg.configuration != null) rec {
      package = module.activationPackage // env // {
        inherit env;
      };
      activate = "${package}/activate";

      packages = module.config.home.packages;
      pathsToCache = packages;
    };
  };
}
