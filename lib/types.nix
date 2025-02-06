lib:
with lib;
{
  nixConfiguration = types.oneOf [
    types.path
    types.attrs
    (types.functionTo types.attrs)
  ];
}
