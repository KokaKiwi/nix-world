{ config, pkgs, lib, sources, modulesPath, ... }:
let
  cfg = config.nixos;

  inherit (config) nixpkgs home;

  module = import "${nixpkgs.path}/nixos/lib/eval-config.nix" {
    modules = [
      (modulesPath + "/nixos")
      cfg.configuration
      ({ lib, ... }: {
        _module.args = {
          pkgs = lib.mkForce nixpkgs.pkgs;
        };
      })
    ]
    ++ lib.optional cfg.integrations.home-manager "${home.source}/nixos"
    ++ lib.optional (config.secrets.file != null) {
      imports = [ "${sources.sops-nix}/modules/sops" ];

      sops.defaultSopsFile = config.secrets.file;
    };

    specialArgs = {
      modulesPath = "${nixpkgs.path}/nixos/modules";
    }
    // lib.optionalAttrs cfg.integrations.srvos {
      srvos = import "${sources.srvos}/nixos";
    }
    // cfg.extraSpecialArgs;
  };

  inherit (module.config) deployment;

  scripts = let
    env = [
      "NIX_SSHOPTS=${lib.escapeShellArg (toString deployment.sshOptions)}"
    ];

    pushCommand = env ++ [
      "nix-copy-closure"
      "--to" "--gzip"
      "${deployment.targetUser}@${deployment.targetHost}"
    ];
    sshCommand = env ++ [ "ssh" "-t" ]
      ++ map lib.escapeShellArg deployment.sshOptions
      ++ [ "${deployment.targetUser}@${deployment.targetHost}" "--" ];
    switchCommand = sshCommand ++ [
      "${module.config.system.build.toplevel}/bin/switch-to-configuration"
    ];

    mkScripts = lib.mapAttrs (scriptName: text:
      pkgs.writeShellScript "${config.name}-nixos-${scriptName}" text
    );
  in mkScripts {
    activate = ''
      ${scripts.push}
      ${scripts.upload-keys}
      ${toString switchCommand} "$@"
    '';
    dry-activate = ''
      ${scripts.push}
      ${toString switchCommand} dry-activate
    '';
    boot = ''
      ${scripts.push}
      ${toString switchCommand} boot
    '';
    check = ''
      ${scripts.push}
      ${toString switchCommand} check
    '';

    upload-keys = ''
    '';

    push = ''
      ${toString pushCommand} ${module.config.system.build.toplevel}
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
  };

  config = {
    systems.nixos = lib.mkIf (cfg.configuration != null) {
      package = pkgs.linkFarm "${config.name}-nixos" entries // env // {
        inherit env;
      };

      inherit (scripts) activate;
    };
  };
}
