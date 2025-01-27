{ config, pkgs, lib, sources, secretsPath, ... }:
with lib;
let
  entries = import "${secretsPath}/secrets.nix";
  secrets = mapAttrs' (name: { path ? null, ... }@entry:
    let
      name' = removeSuffix ".age" name;
      entry' = removeAttrs entry [ "publicKeys" "path" ];
      path' = if builtins.isFunction path
        then entry.path config
        else entry.path;
    in nameValuePair name' (entry' // {
      file = lib.path.append secretsPath name;
      path = mkIf (path != null) path';
    })) entries;

  agenix = pkgs.agenix.override {
    ageBin = "${pkgs.rage}/bin/rage";
  };
in {
  imports = [
    "${sources.agenix}/modules/age-home.nix"
  ];

  home.packages = [ agenix ];

  age.package = pkgs.rage;

  age.identityPaths = [
    "${config.xdg.dataHome}/rage/kira.key"
  ];

  age.secrets = secrets;

  _module.args = {
    secrets = config.age.secrets;
  };
}
