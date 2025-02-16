{ config, pkgs, lib, ... }:
let
  cfg = config.systemd.sysusers;
  usersCfg = config.users;

  userType = with lib; types.submodule {
    options = {
      uid = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      home = mkOption {
        type = types.passwdEntry types.str;
        default = "/var/empty";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };
  groupType = with lib; types.submodule ({ name, ... }: {
    options = {
      gid = mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      members = mkOption {
        type = with types; listOf (passwdEntry str);
        default = [ ];
      };
    };

    config = {
      members = mapAttrsToList (username: user: username) (
        filterAttrs (username: user: elem name user.extraGroups) cfg.users
      );
    };
  });

  configFile = pkgs.writeText "nixusers.conf" ''
    # Users
    ${lib.concatLines (lib.mapAttrsToList (username: user:
      ''u ${username} ${if user.uid != null then toString user.uid else "-"} - ${user.home} -''
    ) cfg.users)}

    # Groups
    ${lib.concatLines (lib.mapAttrsToList (groupname: group:
      ''g ${groupname} ${if group.gid != null then toString group.gid else "-"}''
    ) cfg.groups)}

    # Group members
    ${lib.concatStrings (lib.mapAttrsToList (groupname: group:
      lib.concatMapStrings (username: "m ${username} ${groupname}\n") group.members
    ) cfg.groups)}
  '';
in {
  options.systemd.sysusers = with lib; {
    enable = mkEnableOption "systemd-sysusers" // { default = true; };

    users = mkOption {
      type = types.attrsOf userType;
      default = { };
    };

    groups = mkOption {
      type = types.attrsOf groupType;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."sysusers.d/10-nixusers.conf".source = configFile;

    systemd.services.systemd-sysusers-system-manager = {
      wantedBy = [ "system-manager.target" ];

      serviceConfig = {
        ExecStart = "/usr/bin/systemd-sysusers ${configFile}";
      };
    };
  };
}
