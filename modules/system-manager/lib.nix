{ nixosModulesPath, ... }:
{
  imports = [
    (nixosModulesPath + "/misc/lib.nix")
  ];

  lib.system = {
  };
}
