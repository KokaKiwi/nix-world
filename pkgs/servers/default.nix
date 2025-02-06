{ pkgs }:
let
  inherit (pkgs) kiwiPackages;

  callPackage = kiwiPackages.callPackageIfNewer;
in {
  gotosocial = callPackage ./by-name/go/gotosocial { };
  knot-resolver = callPackage ./dns/knot-resolver {
    _override = true;

    systemd = pkgs.systemdMinimal;
  };
}
