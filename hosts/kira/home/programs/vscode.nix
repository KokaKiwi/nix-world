{ config, pkgs, ... }:
let
  nix-extensions = pkgs.forVSCodeVersion config.programs.vscode.package.version;
in {
  programs.vscode = {
    enable = true;
    package = let
      vscode = pkgs.kiwiPackages.vscodium;
    in config.lib.opengl.wrapPackage vscode { };

    extensions = with nix-extensions.vscode-marketplace; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
    ];

    userSettings = {
      "files.autoSave" = "off";
      "[nix]"."editor.tabSize" = 2;

      "workbench.colorTheme" = "Catppuccin Mocha";
      "catppuccin.accentColor" = "green";

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    };
  };
}
