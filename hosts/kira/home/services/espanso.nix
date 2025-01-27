{ pkgs, ... }:
{
  services.espanso = {
    enable = false; # Broken :(
    package = pkgs.espanso-wayland.override {
      inherit (pkgs.rustTools.stable) rustPlatform;
    };

    configs = {
      default = {
        keyboard_layout = {
          layout = "fr";
        };
      };
    };

    matches = {
      base = { };
      kitty = {
        filter_class = "kitty";
        enable = false;
      };
    };
  };
}
