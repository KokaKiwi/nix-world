{ ... }:
{
  programs.bash.enable = true;

  home.stateVersion = "24.05";

  programs.just = {
    enable = true;

    justfile = {
      enable = true;
      source = ./Justfile;
    };
  };
}
