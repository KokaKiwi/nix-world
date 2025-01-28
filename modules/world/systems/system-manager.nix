{
  config,
  pkgs,
  nixpkgs,
  modulesPath,
  sources,

  configuration,
  extraSpecialArgs ? { },
  ...
}:
let
  system-manager = import sources.system-manager {
    nixpkgs = config.nixpkgs.path;
    pkgs = nixpkgs;
  };

  module = system-manager.lib.makeSystemConfig {
    modules = [
      (modulesPath + "/system-manager")
      configuration
      ({ lib, ... }: {
        nixpkgs.hostPlatform = nixpkgs.hostPlatform.system;
        system-manager.allowAnyDistro = true;

        _module.args = {
          pkgs = lib.mkForce nixpkgs;
        };
      })
    ];

    extraSpecialArgs = extraSpecialArgs // {
      inherit (nixpkgs) nur;
      inherit sources;
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
in rec {
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
}
