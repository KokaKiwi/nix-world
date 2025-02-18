{
  stdenv,
  fetchurl,
  lib,
  makeWrapper,
  electron,
  makeDesktopItem,
  imagemagick,
  commandLineArgs ? "",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian";
  version = "1.8.7";

  src = fetchurl {
    url =
      "https://github.com/obsidianmd/obsidian-releases/releases/download/v${finalAttrs.version}/obsidian-${finalAttrs.version}.tar.gz";
    hash = "sha256-tOP3kXWVmL8aH5QP8E6VtJAf4sLEgVRuXidRU1iJkM8=";
  };

  icon = fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/obsidian \
      --add-flags $out/share/obsidian/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
    install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
    install -m 444 -D "$desktopItem/share/applications/"* \
      -t $out/share/applications/

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none $icon -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
    done

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };

  meta = with lib; {
    description = "Powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    mainProgram = "obsidian";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = licenses.obsidian;
    maintainers = with maintainers; [
      atila
      conradmearns
      zaninime
      qbit
      kashw2
      w-lfchen
    ];
  };
})
