{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.kiwiPackages.neovim.override {
      buildArch = "skylake";
    };

    defaultEditor = true;

    withRuby = false;

    wrapRc = false;

    viAlias = true;
    vimAlias = true;

    python3Package = pkgs.python312;
    extraLuaPackages = ps: with ps; [
      cqueues
      luasocket http
    ];

    tree-sitter = let
      cc = pkgs.stdenv.cc;
    in {
      enable = true;
      package = pkgs.kiwiPackages.neovim.tree-sitter;
      cc = "${cc}/bin/cc";
      nodejs = pkgs.nodejs;
    };
  };

  catppuccin.nvim.enable = false;

  home.packages = [
    config.programs.neovim.tree-sitter.package
  ];
}
