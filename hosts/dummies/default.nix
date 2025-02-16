let
  mkDummy = configuration: meta: {
    imports = [ meta ];

    nixpkgs.version = "24.11";

    nixos = {
      configuration = {
        imports = [
          ./_shared
          configuration
        ];
      };

      integrations.srvos = true;
    };
  };
in {
  vps-cea655b4 = mkDummy ./vps-cea655b4/configuration.nix {
    nixos.deployment = {
      targetHost = "vps-cea655b4.vps.ovh.ca";
      sshOptions = [ "-4" ];
    };
  };
  vps-d353a2f5 = mkDummy ./vps-d353a2f5/configuration.nix {
    nixos.deployment = {
      targetHost = "vps-d353a2f5.vps.ovh.net";
      sshOptions = [ "-4" ];
    };
  };
}
