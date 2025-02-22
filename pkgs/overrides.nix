{ pkgs, super, sources }:
let
  opkgs = import sources.nixpkgs {};
in {
  # Fixup deps
  webkitgtk_4_0 = super.webkitgtk_4_0.override {
    inherit (opkgs) geoclue2;
  };
  webkitgtk_4_1 = super.webkitgtk_4_1.override {
    inherit (opkgs) geoclue2;
  };
  webkitgtk_6_0 = super.webkitgtk_6_0.override {
    inherit (opkgs) geoclue2;
  };

  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.2.3";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-wNNfzF/rCOi4SDLr5hcS0r+x8Rgd5wbpOHvBLiNGPzU=";
    };
  });
}
