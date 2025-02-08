{ pkgs, super, sources }:
let
  inherit (pkgs) lib;

  callPackage = lib.callPackageWith (pkgs // {
    inherit sources;
  });
  importSub = super.lib.callPackageWith {
    inherit pkgs lib super sources;
    inherit callPackage importSub;
    inherit util;
  };

  util = importSub ./util.nix { };

  applications = importSub ./applications { };
  build-support = importSub ./build-support { };
  data = importSub ./data { };
  servers = importSub ./servers { };

  packages = applications // build-support // data // servers;

  overrides = importSub ./overrides.nix { };

  top-level = importSub ./top-level.nix { };
in packages // top-level // overrides
