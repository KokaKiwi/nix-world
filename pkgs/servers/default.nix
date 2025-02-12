{ pkgs, util }:
let
  inherit (pkgs) kiwiPackages;

  callPackage = kiwiPackages.callPackageIfNewer;
in util.callPackagesRecursive {
  directory = ./.;

  inherit callPackage;

  overrides = {
    gotosocial = {
      _override = true;
    };
    knot-resolver = {
      _override = true;

      systemd = pkgs.systemdMinimal;
    };
  };
}
