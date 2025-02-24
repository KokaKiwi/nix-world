{ pkgs, ... }:
{
  programs.xh = {
    enable = true;
    package = pkgs.xh.override {
      withNativeTls = true;
    };

    settings = {
      defaultOptions = [
        "--style=monokai"
      ];
    };
  };
}
