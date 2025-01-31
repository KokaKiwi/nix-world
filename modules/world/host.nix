{ lib, ... }:
{
  options = with lib; {
    name = mkOption {
      type = types.str;
    };

    useLix = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
