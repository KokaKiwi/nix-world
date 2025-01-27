{ config, lib, ... }:
let
  cfg = config.programs.starship;
in {
  programs.starship = {
    enable = true;

    enableFishIntegration = false;

    transience = {
      enable = true;
    };

    presets = [ "nerd-font-symbols" ];

    settings = {
      add_newline = false;
      command_timeout = 750;

      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        format = "[@](bold cyan)[$hostname]($style) ";
      };

      directory = {
        format = "in [$path]($style) ";
      };

      status.disabled = true;

      directory.substitutions = {
        "/boot" = "[boot]";
        "/efi" = "[EFI]";
        "/mnt/secure-data" = "[Secure]";
        "/run/media/kokakiwi/secure-data" = "[Secure]";
        "/mnt/extdata" = "[ExtData]";
        "/mnt/kiwivault" = "[KiwiVault]";
      };
    };
  };

  programs.fish.interactiveShellInit = ''
    if test "$TERM" != "dumb"
      ${config.home.profileDirectory}/bin/starship init fish | source
      ${lib.optionalString cfg.enableTransience "enable_transience"}
    end
  '';
}
