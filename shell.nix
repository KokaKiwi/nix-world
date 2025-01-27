{ ... }:
let
  world = import ./. { };

  inherit (world) pkgs;

  cacheUploader = import ./scripts/cache-uploader.nix world;
  updateChecker = import ./scripts/update-checker.nix world;
in pkgs.mkShell {
  name = "world-shell";

  shellHook = ''
    uploadCache() {
      ${cacheUploader}
    }

    checkUpdates() {
      ${updateChecker}
    }
  '';
}
