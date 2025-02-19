let
  mkDummy = configuration: meta: {
    imports = [ meta ];

    nixpkgs.version = "24.11";

    groups = [ "dummies" ];

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
      targetHost = "167.114.36.46";
    };
  };
  vps-d353a2f5 = mkDummy ./vps-d353a2f5/configuration.nix {
    nixos.deployment = {
      targetHost = "51.75.206.42";
    };
  };
  vps-do-nyc1-01 = mkDummy ./vps-do-nyc1-01/configuration.nix {
    nixos.deployment = {
      targetHost = "146.190.220.156";
    };
  };
  vps-do-ams3-01 = mkDummy ./vps-do-ams3-01/configuration.nix {
    nixos.deployment = {
      targetHost = "165.232.94.202";
    };
  };
}
