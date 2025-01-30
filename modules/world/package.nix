{ config, pkgs, lib, ... }:
let
  json = pkgs.formats.json { };

  nodeinfo = {
    inherit (config) name;
    inherit (config.nixpkgs) version;
  };

  activateScript = pkgs.writeShellScript "activate-${config.name}"
    (lib.concatStringsSep "\n" (lib.mapAttrsToList (name: { system, ... }: system.activate) config.systems));
in {
  options = with lib; {
    package = mkOption {
      type = types.package;
    };
  };

  config = {
    package = let
      base = {
        activate = activateScript;
        "nodeinfo.json" = json.generate "node-${config.name}.json" nodeinfo;
      };
      hostPackages = lib.mapAttrs (name: { system, ... }: system.package) config.systems;

      final = base // hostPackages;
    in pkgs.linkFarm config.name final // hostPackages;
  };
}
