{ lib

, writeShellScriptBin
, substituteAll

, cargoBin ? "cargo"
}:
let
  files = {
    ".mise.toml" = {
      src = substituteAll {
        src = ./mise.toml;
        inherit cargoBin;
      };
      overwrite = false;
    };
    ".neoconf.json" = {
      src = ./neoconf.json;
      overwrite = false;
    };
    "Justfile" = {
      src = ./Justfile.base;
    };
  };
in writeShellScriptBin "cargo-setup-project" ''
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: {
    src,
    overwrite ? true,
  }: lib.concatStringsSep " " (
    (lib.optional (!overwrite) "[[ ! -f \"${name}\" ]] &&")
    ++ [
      "cp -Tr --no-preserve=mode ${src} ${name}"
    ]
  )) files)}
''
