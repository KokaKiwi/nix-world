{ config, pkgs, lib, specialArgs, ... }:
let
  world = config;

  hostType = lib.types.submoduleWith {
    class = "nix-host";

    modules = [
      ./host
      ({ name, ... }: {
        name = lib.mkDefault name;
      })
    ];

    specialArgs = specialArgs // {
      inherit world;
      inherit (world) hosts;
    };
  };

  groupType = lib.types.submodule ({ name, config, ... }: {
    options = with lib; {
      members = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };

      package = mkOption {
        type = types.package;
        internal = true;
        readOnly = true;
      };
    };

    config = {
      members = lib.pipe world.hosts [
        (lib.filterAttrs (_: host: lib.elem name host.groups))
        (lib.mapAttrsToList (_: host: host.name))
      ];

      package = let
        hosts = lib.listToAttrs (map (name: lib.nameValuePair name world.hosts.${name}) config.members);
        hostPackages = lib.mapAttrs (name: host: host.package) hosts;
        entries = hostPackages // {
          activate = pkgs.writeShellScript "activate-${name}"
            (lib.concatStringsSep "\n" (lib.mapAttrsToList (name: host: "${host.package}/activate") hosts));
        };
      in pkgs.linkFarm name entries // hostPackages // {
        inherit hosts;
      };
    };
  });
in {
  options = with lib; {
    hosts = mkOption {
      type = types.attrsOf hostType;
      default = { };
    };
    hostGroups = mkOption {
      type = types.attrsOf groupType;
      default = { };
    };

    package = mkOption {
      type = types.package;
      internal = true;
      readOnly = true;
    };
  };

  config = {
    hostGroups = lib.pipe world.hosts [
      (lib.mapAttrsToList (name: host: host.groups))
      lib.concatLists
      lib.unique
      (map (name: lib.nameValuePair name { }))
      lib.listToAttrs
    ];

    package = let
      hostPackages = lib.mapAttrs (name: host: host.package) config.hosts;
      hostGroupPackages = lib.mapAttrs (name: hostGroup: hostGroup.package) config.hostGroups;
      entries = hostPackages // hostGroupPackages // {
        activate = pkgs.writeShellScript "activate-world"
          (lib.concatStringsSep "\n" (lib.mapAttrsToList (name: host: "${host.package}/activate") config.hosts));
      };
    in pkgs.linkFarm "world" entries // hostPackages // hostGroupPackages // {
      inherit (config) hosts hostGroups;
    };
  };
}
