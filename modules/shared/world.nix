{ lib, ... }:
{
  options.cluster.world = with lib; {
    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };
}
