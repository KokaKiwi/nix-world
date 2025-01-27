{ pkgs, lib, ... }:
{
  lib.package = {
    wrapPackage = drv: {
      suffix ? "",
      nativeBuildInputs ? [ ],
      makeWrapper ? pkgs.makeShellWrapper
    }: buildCommand: drv.overrideAttrs (super: {
      name = "${drv.name}${suffix}";

      nativeBuildInputs = [
        makeWrapper
      ] ++ nativeBuildInputs;

      separateDebugInfo = false;
      preferLocalBuild = true;

      buildCommand = ''
        set -eo pipefail

        ${lib.concatMapStringsSep "\n" (outputName: ''
          echo "Copying output ${outputName}"

          cp -rs --no-preserve=mode ${drv.${outputName}} ''$${outputName}
        '') (super.outputs or [ "out" ])}

        # Replaces package references in .desktop files
        for f in $out/share/applications/*.desktop; do
          if ! grep -q "${drv.out}" "$f"; then
            continue
          fi

          src="$(readlink "$f")"
          rm "$f"
          sed "s|${drv.out}|$out|g" "$src" > "$f"
        done

        ${buildCommand}
      '';
    });
  };
}
