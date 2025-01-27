{ config, ... }:
{
  programs.mise = {
    enable = true;

    globalConfig = {
      tools = {
        crystal = "latest";
        deno = "latest";
        gradle = "latest";
      };
    };

    settings = {
      trusted_config_paths = [
        "${config.home.homeDirectory}/projects"
      ];

      experimental = true;
      legacy_version_file = false;
      pipx_uvx = true;
    };
  };
}
