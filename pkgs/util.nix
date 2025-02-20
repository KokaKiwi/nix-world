{ pkgs, super }:
let
  inherit (super) lib;
in rec {
  callPackagesRecursive = {
    directory,

    callPackage ? pkgs.callPackage,
    overrides ? { },
  }: lib.concatMapAttrs (name: type: let
    path = lib.path.append directory name;
    defaultPath = lib.findFirst lib.pathExists null [
      (lib.path.append path "default.nix")
      (lib.path.append path "package.nix")
    ];

    drv = callPackage defaultPath { };

    args = let
      entry = overrides.${name} or { };
    in if lib.isFunction entry
      then entry drv
      else entry;
    callPackage' = args._callPackage or callPackage;

  in if lib.hasPrefix "_" name then { }
  else if defaultPath != null then {
    ${name} = callPackage' defaultPath (lib.removeAttrs args [ "_callPackage" ]);
  }
  else if type == "directory" then
    callPackagesRecursive {
      directory = path;

      inherit callPackage overrides;
    }
  else { }) (builtins.readDir directory);
}
