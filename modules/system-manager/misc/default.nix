{ lib, ... }:
{
  options = with lib; let
    rawOption = default: mkOption {
      type = types.raw;
      inherit default;
    };
  in {
    system = {
      stateVersion = mkOption {
        type = types.str;
        default = trivial.release;
      };

      activationScripts = rawOption { };
      build = rawOption { };
      checks = rawOption { };
    };

    networking.dhcpcd = rawOption {
      enable = false;
    };
    networking.resolvconf = rawOption {
      enable = false;
    };
    services = {
      openssh = rawOption { enable = false; };
      resolved = rawOption { enable = false; };
    };
  };
}
