{ ... }:
let
  world = import ./. { };

  inherit (world) pkgs lib;

  cacheUploader = import ./scripts/cache-uploader.nix world.env;
  updateChecker = import ./scripts/update-checker.nix world.env;

  mkShells = {
    shells,
    ...
  }@args: let
    args' = lib.removeAttrs args [ "shells" ];
  in lib.mapAttrs (name: shellArgs: pkgs.mkShell (args' // shellArgs // {
    name = "${name}-shell";
  })) shells;

  shells = mkShells {
    shells.default = { };

    shells.check = {
      shellHook = ''
        checkUpdates() {
          ${updateChecker}
        }
      '';
    };
    shells.upload-cache = {
      shellHook = ''
        uploadCache() {
          ${cacheUploader}
        }
      '';
    };
  };
in shells.default // shells
