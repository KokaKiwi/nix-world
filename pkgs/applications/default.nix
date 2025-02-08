{ pkgs, super, sources }:
let
  inherit (pkgs) kiwiPackages;
  inherit (pkgs) kdePackages rustTools;
  callPackage = kiwiPackages.callPackageIfNewer;

  inherit (super) lib;

  nixd = callPackage ./development/tools/language-servers/nixd {
    _override = true;

    llvmPackages = pkgs.llvmPackages_19;

    _overrideArgs = {
      nix = pkgs.nixVersions.stable_upstream;
    };
  };

  callPackagesRecursive = {
    directory,

    callPackage ? pkgs.callPackage,
    overrides ? { },
  }: lib.concatMapAttrs (name: type: let
    path = lib.path.append directory name;

    args = overrides.${name} or { };
    callPackage' = args._callPackage or callPackage;

    defaultPath = lib.findFirst lib.pathExists null [
      (lib.path.append path "default.nix")
      (lib.path.append path "package.nix")
    ];
  in if defaultPath != null then {
    ${name} = callPackage' defaultPath (lib.removeAttrs args [ "_callPackage" ]);
  }
  else if type == "directory" then
    callPackagesRecursive {
      directory = path;

      inherit callPackage overrides;
    }
  else { }) (builtins.readDir directory);
in callPackagesRecursive {
  directory = ./.;

  inherit callPackage;

  overrides = {
    activate-linux._override = true;
    commitizen._callPackage = pkgs.python3Packages.callPackage;
    kitty = {
      go = pkgs.go_1_23;
      buildGoModule = pkgs.buildGo123Module;
    };
    module-server = {
      inherit (rustTools.stable) cargo;
    };
    syncthingtray._callPackage = kdePackages.callPackage;
    tor = {
      _override = true;

      systemd = pkgs.systemdMinimal;
    };
    vesktop = {
      pnpm = pkgs.pnpm_9;
    };
  };
} // {
  fixx = callPackage "${sources.ixx}/fixx/derivation.nix" { };
  ixx = callPackage "${sources.ixx}/ixx/derivation.nix" { };
  inherit (nixd) nixf nixt nixd;
}
