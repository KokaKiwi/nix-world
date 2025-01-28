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

  entries = module.entries // {
    etc = module.config.build.etc.staticEnv;
  };
in rec {
  package = pkgs.linkFarm "system-manager" entries // {
    inherit (module) config;
  };
  activate = pkgs.writeShellScript "activate" ''
    sudo ${package}/bin/activate
    sudo ${package}/bin/register-profile
  '';

  packages = module.config.environment.systemPackages;
  pathsToCache = packages;
}
