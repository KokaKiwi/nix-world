{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;

    package = pkgs.nushell.override {
      additionalFeatures = p: [
        "system-clipboard"
      ];
    };
  };
}
