{ lib, stdenv

, fetchurl
, makeDesktopItem
, makeWrapper

, electron
, imagemagick
}:
let
  icon = fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };
in stdenv.mkDerivation rec {
  pname = "obsidian";
  version = "1.7.7";

  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
    hash = "sha256-6IHqBvZx2yxQAvADi3Ok5Le3ip2/c6qafQ3FSpPT0po=";
  };

  nativeBuildInputs = [ makeWrapper imagemagick ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/obsidian \
      --add-flags $out/share/obsidian/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    install -m 444 -D resources/app.asar $out/share/obsidian/app.asar
    install -m 444 -D resources/obsidian.asar $out/share/obsidian/obsidian.asar
    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -background none -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "A powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    license = licenses.obsidian;
    maintainers = with maintainers; [ atila conradmearns zaninime qbit kashw2 w-lfchen ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
