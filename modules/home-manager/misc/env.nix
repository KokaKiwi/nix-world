{ lib, ... }:
{
  options.env = with lib; mkOption {
    type = types.attrs;
    default = { };
    description = ''
      Extra data to pass in evaluation env
    '';
  };
}
