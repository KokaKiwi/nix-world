{ pkgs, ... }:
{
  config = {
    programs.silicon = {
      enable = true;
      package = pkgs.silicon.override {
        python3 = pkgs.python312;
      };

      settings = ''
        --font "FiraCode Nerd Font Mono=15"
      '';
    };
  };
}
