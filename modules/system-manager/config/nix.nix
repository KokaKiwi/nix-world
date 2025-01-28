{ config, lib, nixosModulesPath, ... }:
let
  cfg = config.nix;
in {
  imports = [
    (nixosModulesPath + "/config/nix.nix")
  ];

  config = lib.mkIf cfg.enable {
    nix.settings = {
      build-users-group = lib.mkDefault "nixbld";
    };
  };
}
