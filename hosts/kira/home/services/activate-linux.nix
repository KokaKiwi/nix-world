{ pkgs, ... }:
{
  services.activate-linux = {
    enable = true;
    package = pkgs.activate-linux.override {
      # TODO
      # backends = [ "wayland" ];
    };

    config = {
      text-title = "Activate Nix/Arch::OS";
      text-message = "{42999158-ae9f-5b44-8834-27675aacf427}";

      scale = 1.3;
    };
  };
}
