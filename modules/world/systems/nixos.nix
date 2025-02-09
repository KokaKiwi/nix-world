{ config, pkgs, lib, hosts, sources, modulesPath, ... }:
let
  cfg = config.nixos;

  inherit (config) nixpkgs home;

  module = import "${nixpkgs.path}/nixos/lib/eval-config.nix" {
    modules = [
      (modulesPath + "/nixos")
      (modulesPath + "/shared")
      cfg.configuration
      {
        _module.args = {
          pkgs = lib.mkForce nixpkgs.pkgs;
        };
      }
    ]
    ++ lib.optionals cfg.integrations.home-manager [
      "${home.source}/nixos"
      {
        home-manager = {
          sharedModules = [
            (modulesPath + "/home-manager")
          ]
          ++ lib.optionals (config.secrets.file != null) [
            "${sources.sops-nix}/modules/home-manager/sops.nix"
            {
              sops.defaultSopsFile = config.secrets.file;
            }
          ]
          ++ nixpkgs.pkgs.nur.repos.kokakiwi.modules.home-manager.all-modules;

          extraSpecialArgs = cfg.extraSpecialArgs // {
            inherit hosts sources;
          };
        };
      }
    ]
    ++ lib.optional (config.secrets.file != null) {
      imports = [ "${sources.sops-nix}/modules/sops" ];

      sops.defaultSopsFile = config.secrets.file;
    }
    ++ nixpkgs.pkgs.nur.repos.kokakiwi.modules.nixos.all-modules;

    specialArgs = {
      inherit hosts sources;

      modulesPath = "${nixpkgs.path}/nixos/modules";
    }
    // lib.optionalAttrs cfg.integrations.srvos {
      srvos = import "${sources.srvos}/nixos";
    }
    // cfg.extraSpecialArgs;
  };

  scripts = let
    env = [
      "NIX_SSHOPTS=${lib.escapeShellArg (toString cfg.deployment.sshOptions)}"
    ];

    pushCommand = env ++ [
      "nix-copy-closure"
      "--to" "--gzip"
      "${cfg.deployment.targetUser}@${cfg.deployment.targetHost}"
    ];
    sshCommand = env ++ [ "ssh" "-t" ]
      ++ map lib.escapeShellArg cfg.deployment.sshOptions
      ++ [ "${cfg.deployment.targetUser}@${cfg.deployment.targetHost}" "--" ];
    switchCommand = sshCommand
      ++ lib.optionals cfg.deployment.useSudo [ "sudo" "-H" "--" ]
      ++ [ "${module.config.system.build.toplevel}/bin/switch-to-configuration" ];

    mkScripts = lib.mapAttrs (scriptName: text:
      pkgs.writeShellScript "${config.name}-nixos-${scriptName}" text
    );
  in mkScripts {
    activate = ''
      ${scripts.push}
      ${scripts.register-profile}
      ${toString switchCommand} switch
    '';
    boot = ''
      ${scripts.push}
      ${scripts.register-profile}
      ${toString switchCommand} boot
    '';
    dry-activate = ''
      ${scripts.push}
      ${toString switchCommand} dry-activate
    '';
    check = ''
      ${scripts.push}
      ${toString switchCommand} check
    '';

    push = ''
      ${toString pushCommand} ${module.config.system.build.toplevel}
    '';
    register-profile = ''
      ${toString sshCommand} nix-env --profile /nix/var/nix/profiles/system --set ${module.config.system.build.toplevel}
    '';
  };

  entries = {
    activate = scripts.activate;
    system = module.config.system.build.toplevel;
  } // lib.mapAttrs' (name: script: {
    name = "bin/${name}";
    value = script;
  }) scripts;

  env = {
    inherit module;
    inherit (module) config options pkgs;
    inherit (module.pkgs) lib;
  };
in {
  options.nixos = with lib; {
    configuration = mkOption {
      type = types.nullOr world.types.nixConfiguration;
      default = null;
    };
    extraSpecialArgs = mkOption {
      type = types.attrs;
      default = { };
    };

    integrations = let
      mkIntegrationOption = name: mkOption {
        type = types.bool;
        default = false;
      };
    in {
      home-manager = mkIntegrationOption "home-manager";
      srvos = mkIntegrationOption "srvos";
    };

    deployment = {
      targetHost = mkOption {
        type = types.str;
        default = config.name;
      };
      targetPort = mkOption {
        type = types.nullOr types.port;
        default = null;
      };
      targetUser = mkOption {
        type = types.str;
        default = "root";
      };

      useSudo = mkOption {
        type = types.bool;
        default = cfg.deployment.targetUser != "root";
      };

      sshOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = {
    systems.nixos = lib.mkIf (cfg.configuration != null) {
      package = pkgs.linkFarm "${config.name}-nixos" entries // env // {
        inherit env;
      };

      inherit (scripts) activate;

      packages = module.config.cluster.world.packages;
      pathsToCache = module.config.environment.systemPackages ++ module.config.cluster.world.packages;
    };
  };
}
