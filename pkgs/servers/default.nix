{ pkgs }:
let
  inherit (pkgs) kiwiPackages;

  callPackage = kiwiPackages.callPackageIfNewer;
in {
  knot-resolver = callPackage ./dns/knot-resolver {
    _override = true;

    systemd = pkgs.systemdMinimal;
  };
}
