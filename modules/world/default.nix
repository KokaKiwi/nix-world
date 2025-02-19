{ config, pkgs, lib, specialArgs, ... }:
let
  hostType = lib.types.submoduleWith {
    class = "nix-host";

    modules = [
      ./host
      ({ name, ... }: {
        name = lib.mkDefault name;
      })
    ];

    specialArgs = specialArgs // {
      world = config;
      inherit (config) hosts;
    };
  };
in {
  options = with lib; {
    hosts = mkOption {
      type = types.attrsOf hostType;
      default = { };
    };

    package = mkOption {
      type = types.package;
      internal = true;
      readOnly = true;
    };
  };

  config = {
    package = let
      hostPackages = lib.mapAttrs (name: host: host.package) config.hosts;
    in pkgs.linkFarm "world" hostPackages // hostPackages // {
      inherit (config) hosts;
    };
  };
}
