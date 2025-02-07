{ lib

, fetchurl

, appimageTools
}:
appimageTools.wrapType2 rec {
  pname = "hoppscotch";
  version = "25.1.1-0";

  src = fetchurl {
    url = "https://github.com/hoppscotch/releases/releases/download/v${version}/Hoppscotch_linux_x64.AppImage";
    hash = "sha256-M9fQx4NBotLPe8i43E1uqHpFeoXdHGQePp4zgzbzDdM=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 { inherit pname version src; };
  in ''
    # Install .desktop files
    install -Dm444 ${appimageContents}/hoppscotch.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/hoppscotch.png -t $out/share/pixmaps
  '';

  meta = {
    description = "Open source API development ecosystem";
    longDescription = ''
      Hoppscotch is a lightweight, web-based API development suite. It was built
      from the ground up with ease of use and accessibility in mind providing
      all the functionality needed for API developers with minimalist,
      unobtrusive UI.
    '';
    homepage = "https://hoppscotch.com";
    downloadPage = "https://hoppscotch.com/downloads";
    changelog = "https://github.com/hoppscotch/hoppscotch/releases/tag/20${lib.head (lib.splitString "-" version)}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DataHearth ];
    mainProgram = "hoppscotch";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
