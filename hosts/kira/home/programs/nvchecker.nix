{ config, pkgs, lib, ... }:
{
  programs.nvchecker = {
    enable = true;
    package = let
      python3Packages = pkgs.python312Packages;
      nvchecker = python3Packages.nvchecker.overridePythonAttrs (super: rec {
        version = "2.16";

        src = pkgs.fetchFromGitHub {
          owner = "lilydjwg";
          repo = "nvchecker";
          rev = "v${version}";
          hash = "sha256-HdL3BnjQZzKXtjhQqDst6dJH82g3BONFsGUnwzDMRDA=";
        };
      });
    in config.lib.python.extendPackageEnv nvchecker (_: lib.flatten (lib.attrValues nvchecker.optional-dependencies));
  };
}
