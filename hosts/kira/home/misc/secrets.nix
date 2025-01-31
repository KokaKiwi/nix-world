{ config, ... }:
{
  sops.age.keyFile = "${config.xdg.dataHome}/rage/kira.key";

  sops.secrets = {
    bitwarden-session-key = { };

    cargo-credentials = {
      path = "${config.home.homeDirectory}/.cargo/credentials";
    };

    booru-config = {
      path = "${config.xdg.configHome}/booru/config.toml";
    };
    hub-config = {
      path = "${config.xdg.configHome}/hub";
    };
    nvchecker-keyfile = {
      path = "${config.xdg.configHome}/nvchecker/keyfile.toml";
    };
  };
}
