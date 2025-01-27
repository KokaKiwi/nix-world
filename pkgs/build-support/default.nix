{ callPackage }:
let
  makeWrapper = callPackage ./make-wrapper {};
in {
  addUsageCompletion = callPackage ./add-usage-completion {};

  inherit (makeWrapper)
    wrapProgram wrapProgramBin;
}
