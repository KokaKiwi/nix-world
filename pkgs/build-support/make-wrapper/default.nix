{ lib, runCommand, makeWrapper }:
rec {
  wrapProgram = name: {
    program,
    env ? { },
    pathPackages ? [ ],
    chdir ? null,
    extraArgs ? [ ],
    prefix ? null,
  }: let
    outName = if prefix != null then "$out${prefix}/${name}" else "$out";

    finalArgs =
      lib.optionals (pathPackages != [ ]) [ "--prefix" (lib.makeBinPath pathPackages) ] ++
      lib.mapAttrsToList (name: value: "--set ${name} ${toString value}") env ++
      lib.optionals (chdir != null) [ "--chdir" chdir ] ++
      extraArgs;
  in runCommand name {
    nativeBuildInputs = [ makeWrapper ];
  } ''
    mkdir -p $(dirname "${outName}")
    makeWrapper ${program} "${outName}" ${lib.concatStringsSep " " finalArgs}
  '';

  wrapProgramBin = name: args: wrapProgram name (args // { prefix = "/bin"; });
}
