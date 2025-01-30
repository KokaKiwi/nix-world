{
  config,
  nixpkgs,
  modulesPath,
  sources,

  configuration,
  extraSpecialArgs ? { },
  ...
}:
let
  home-manager = if config.nixpkgs.version == "unstable"
    then sources.home-manager
    else sources."home-manager-${config.nixpkgs.version}";

  module = import "${home-manager}/modules" {
    pkgs = nixpkgs;
    check = true;

    configuration = { lib, ... }: {
      imports = [
        (modulesPath + "/home-manager")
        configuration
      ]
      ++ nixpkgs.nur.repos.kokakiwi.modules.home-manager.all-modules;

      _module.args = {
        pkgs = lib.mkForce nixpkgs;
      };
    };

    extraSpecialArgs = extraSpecialArgs // {
      inherit sources;
    };
  };

  env = {
    inherit module;
    inherit (module) config options pkgs;
    inherit (module.pkgs) lib;
  } // module.config.env;
in rec {
  package = module.activationPackage // env // {
    inherit env;
  };
  activate = "${package}/activate";

  packages = module.config.home.packages;
  pathsToCache = packages;
}
