{ pkgs, ... }:
{
  programs.xh = {
    enable = true;
    package = pkgs.xh.override {
      withNativeTls = true;
      openssl = pkgs.openssl_3_3;
    };

    settings = {
      defaultOptions = [
        "--style=monokai"
      ];
    };
  };
}
