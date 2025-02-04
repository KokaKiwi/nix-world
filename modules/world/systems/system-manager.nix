{ config, pkgs, lib, hosts, sources, modulesPath, ... }:
let
  cfg = config.system;

  inherit (config) nixpkgs;

  system-manager = import sources.system-manager {
    nixpkgs = nixpkgs.path;
    pkgs = nixpkgs.pkgs;
  };

  module = system-manager.lib.makeSystemConfig {
    modules = [
      (modulesPath + "/shared")
      (modulesPath + "/system-manager")
      cfg.configuration
      ({ lib, ... }: {
        nixpkgs.hostPlatform = nixpkgs.pkgs.hostPlatform.system;
        system-manager.allowAnyDistro = true;

        _module.args = {
          pkgs = lib.mkForce nixpkgs.pkgs;
        };
      })
    ];

    extraSpecialArgs = cfg.extraSpecialArgs // {
      inherit (nixpkgs.pkgs) nur;
      inherit hosts sources;
    };
  };

  activate = pkgs.writeShellScript "activate" ''
    HERE=$(realpath $(dirname "$0"))
    sudo $HERE/bin/activate
    sudo $HERE/bin/register-profile
  '';
  entries = module.entries // {
    inherit activate;
    etc = module.config.build.etc.staticEnv;
  };
in {
  options.system = with lib; {
    configuration = mkOption {
      type = types.nullOr world.types.nixConfiguration;
      default = null;
    };
    extraSpecialArgs = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = {
    systems.system = lib.mkIf (cfg.configuration != null) rec {
      package = pkgs.linkFarm "system-manager" entries // {
        inherit module;
        inherit (module) config options pkgs;
        inherit (module.pkgs) lib;
      };
      activate = pkgs.writeShellScript "activate" ''
        ${package}/activate
      '';

      packages = module.config.environment.systemPackages;
      pathsToCache = packages;
    };
  };
}
