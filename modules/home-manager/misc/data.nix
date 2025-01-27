{ lib, ... }:
{
  options.data = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
}
