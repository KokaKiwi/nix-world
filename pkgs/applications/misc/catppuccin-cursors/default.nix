{ lib, stdenvNoCC

, fetchFromGitHub

, hyprcursor
, inkscape
, just
, xcur2png
, xorg
}:
let
  dimensions = {
    palette = [ "frappe" "latte" "macchiato" "mocha" ];
    color = [ "Blue" "Dark" "Flamingo" "Green" "Lavender" "Light" "Maroon" "Mauve" "Peach" "Pink" "Red" "Rosewater" "Sapphire" "Sky" "Teal" "Yellow" ];
  };
  variantName = { palette, color }: palette + color;
  variants = lib.mapCartesianProduct variantName dimensions;
in stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-cursors";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v${version}";
    hash = "sha256-CuzD6O/RImFKLWzJoiUv7nlIdoXNvwwl+k5mTeVIY10=";
  };

  nativeBuildInputs = [
    just
    inkscape
    xorg.xcursorgen
    xcur2png
    hyprcursor
  ];

  outputs = variants ++ [ "out" ]; # dummy "out" output to prevent breakage

  outputsToInstall = [];

  buildPhase = ''
    runHook preBuild

    patchShebangs .

    just all_with_hyprcursor

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for output in $(getAllOutputNames); do
      if [ "$output" != "out" ]; then
        local outputDir="''${!output}"
        local iconsDir="$outputDir"/share/icons

        mkdir -p "$iconsDir"

        # Convert to kebab case with the first letter of each word capitalized
        local variant=$(sed 's/\([A-Z]\)/-\1/g' <<< "$output")
        local variant=''${variant,,}

        mv "dist/catppuccin-$variant-cursors" "$iconsDir"
      fi
    done

    # Needed to prevent breakage
    mkdir -p "$out"

    runHook postInstall
  '';

  meta = {
    description = "Catppuccin cursor theme based on Volantes";
    homepage = "https://github.com/catppuccin/cursors";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dixslyf ];
  };
}
