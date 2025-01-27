{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.neovim;

  pluginType = types.submodule ({ config, ... }: {
    options = {
      type = mkOption {
        type = types.enum [ "viml" "lua" ];
        default = "viml";
      };

      package = mkOption {
        type = types.package;
      };
      plugin = mkOption {
        type = with types; nullOr package;
        default = null;
        visible = false;
      };

      optional = mkOption {
        type = types.bool;
        default = false;
      };

      config = mkOption {
        type = with types; nullOr lines;
        default = null;
      };
    };

    config = {
      package = mkIf (config.plugin != null) config.plugin;
    };
  });

  normalizedPlugins = flip map cfg.plugins (plugin:
    if (plugin ? package) then plugin else { package = plugin; }
  );

  generatedConfigs = let
    grouped = groupBy (plugin: plugin.type) normalizedPlugins;
  in flip mapAttrs grouped (type: plugins: let
    configs = flatten (flip map plugins (plugin: optional (plugin.config != null) plugin.config));
  in concatStringsSep "\n" configs);

  neovimUtils = pkgs.neovimUtils.override {
    python3Packages = cfg.python3Package.pkgs;

    neovim-unwrapped = cfg.package;
  };
  neovimConfig = let
    base = neovimUtils.makeNeovimConfig ({
      inherit (cfg)
        viAlias vimAlias
        withPython3 withNodeJs withRuby withPerl
        extraPython3Packages extraLuaPackages;

      plugins = flip map normalizedPlugins (plugin: {
        plugin = plugin.package;
        inherit (plugin) optional;
      } // optionalAttrs (plugin.type == "viml" && plugin.config != null) {
        inherit (plugin) config;
      });

      customRC = cfg.extraRc;
      luaRcContent = (generatedConfigs.lua or "") + cfg.extraLuaRc;

      wrapRc = let
        hasConfig = (generatedConfigs.viml or "") != "" || (generatedConfigs.lua or "") != "" || cfg.extraLuaRc != "";
      in if cfg.wrapRc != null then cfg.wrapRc else hasConfig;
    } // cfg.extraNeovimConfigArgs);
  in base // {
    wrapperArgs = base.wrapperArgs ++ cfg.extraWrapperArgs;
  };
in {
  disabledModules = [
    "programs/neovim.nix"
  ];

  options.programs.neovim = {
    enable = mkEnableOption "neovim";

    package = mkPackageOption pkgs "neovim-unwrapped" { };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
    };

    viAlias = mkOption {
      type = types.bool;
      default = false;
    };
    vimAlias = mkOption {
      type = types.bool;
      default = false;
    };
    vimdiffAlias = mkOption {
      type = types.bool;
      default = false;
    };

    withPython3 = mkOption {
      type = types.bool;
      default = true;
    };
    withNodeJs = mkOption {
      type = types.bool;
      default = false;
    };
    withRuby = mkOption {
      type = types.bool;
      default = true;
    };
    withPerl = mkOption {
      type = types.bool;
      default = false;
    };

    wrapRc = mkOption {
      type = with types; nullOr bool;
      default = null;
    };
    extraRc = mkOption {
      type = types.lines;
      default = "";
    };
    extraLuaRc = mkOption {
      type = types.lines;
      default = "";
    };

    plugins = mkOption {
      type = with types; listOf (either package pluginType);
      default = [ ];
    };

    python3Package = mkPackageOption pkgs "python3" { };

    extraLuaPackages = mkOption {
      type = with types; functionTo (listOf package);
      default = _: [ ];
      defaultText = literalExpression "ps: [ ]";
    };
    extraPython3Packages = mkOption {
      type = with types; functionTo (listOf package);
      default = _: [ ];
      defaultText = literalExpression "ps: [ ]";
    };
    overridePackages = mkOption {
      type = with types; listOf package;
      default = [ ];
    };
    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
    };
    envVariables = mkOption {
      type = types.attrs;
      default = { };
    };

    extraNeovimConfigArgs = mkOption {
      type = types.attrs;
      default = { };
    };
    extraStartupCommands = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    extraWrapperArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    tree-sitter = {
      enable = mkEnableOption "Tree-Sitter";

      package = mkPackageOption pkgs "tree-sitter" { };
      cc = mkOption {
        type = with types; nullOr (either package path);
        default = null;
      };
      nodejs = mkOption {
        type = with types; nullOr package;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      finalPackage = pkgs.wrapNeovimUnstable cfg.package neovimConfig;

      overridePackages =
        optional (cfg.tree-sitter.enable && cfg.tree-sitter.nodejs != null) cfg.tree-sitter.nodejs;
      extraPackages =
        optional (cfg.tree-sitter.enable) cfg.tree-sitter.package;

      extraWrapperArgs =
        optionals (cfg.overridePackages != [ ]) [
          "--prefix" "PATH" ":"
          (makeBinPath cfg.overridePackages)
        ]
        ++ optionals (cfg.extraPackages != [ ]) [
          "--suffix" "PATH" ":"
          (makeBinPath cfg.extraPackages)
        ]
        ++ optionals (cfg.tree-sitter.enable && cfg.tree-sitter.cc != null && !isDerivation cfg.tree-sitter.cc) [
          "--set" "CC" (toString cfg.tree-sitter.cc)
        ]
        ++ flatten (mapAttrsToList (name: value: [
          "--set" name (toString value)
        ]) cfg.envVariables)
        ++ flatten (map (cmd: [
          "--add-flags" ''--cmd "${cmd}"''
        ]) cfg.extraStartupCommands);
      extraStartupCommands = [
        "set shell=${pkgs.bashInteractive}/bin/bash"
      ];
    };

    home.packages = [ cfg.finalPackage ];

    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = "nvim";
    };

    programs.bash.shellAliases = mkIf cfg.vimdiffAlias {
      vimdiff = "nvim -d";
    };
    programs.fish.shellAliases = mkIf cfg.vimdiffAlias {
      vimdiff = "nvim -d";
    };
    programs.zsh.shellAliases = mkIf cfg.vimdiffAlias {
      vimdiff = "nvim -d";
    };
  };
}
