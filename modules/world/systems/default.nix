{ lib, ... }:
{
  imports = [
    ./home-manager.nix
    ./system-manager.nix

    ./nixos.nix
  ];

  options = with lib; {
    systems = mkOption {
      type = types.attrsOf (types.submodule {
        freeformType = types.attrs;

        options = {
          package = mkOption {
            type = types.package;
            readOnly = true;
          };
          activate = mkOption {
            type = types.path;
            readOnly = true;
          };

          packages = mkOption {
            type = types.listOf types.package;
            default = [ ];
          };
          pathsToCache = mkOption {
            type = types.listOf types.path;
            default = [ ];
          };
        };
      });
      default = { };
    };
  };
}
