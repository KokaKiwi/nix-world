{ pkgs, super }:
let
  inherit (pkgs) callPackage;
in {
  gotosocial = callPackage ./gotosocial { };
}
