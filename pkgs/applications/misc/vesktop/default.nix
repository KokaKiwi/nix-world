{ lib, stdenv

, fetchFromGitHub
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, substituteAll

, nodejs
, pnpm
, electron
, libicns
, libpulseaudio
, pipewire

, withTTS ? true
, withSystemVencord ? false, vencord
}:
stdenv.mkDerivation (final: {
  pname = "vesktop";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vesktop";
    rev = "v${final.version}";
    hash = "sha256-HlT7ddlrMHG1qOCqdaYjuWhJD+5FF1Nkv2sfXLWd07o=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (final) pname version src;
    hash = "sha256-rizJu6v04wFEpJtakC2tfPg/uylz7gAOzJiXvUwdDI4=";
  };

  patches = [
    ./disable-update-checker.patch
  ]
  ++ lib.optional withSystemVencord (substituteAll {
    src = ./use-system-vencord.patch;
    inherit vencord;
  });

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper

    nodejs
    pnpm.configHook
  ];
  buildInputs = [
    libpulseaudio
    pipewire
    stdenv.cc.cc.lib
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  buildPhase = ''
    runHook preBuild

    pnpm build
    ./node_modules/.bin/electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/Vesktop
    cp -r dist/linux-*unpacked/resources $out/opt/Vesktop/

    cd build
    ${libicns}/bin/icns2png -x icon.icns
    for file in icon_*x32.png; do
      file_suffix=''${file//icon_}
      install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vesktop.png
    done

    makeWrapper ${electron}/bin/electron $out/bin/vesktop \
      --add-flags $out/opt/Vesktop/resources/app.asar \
      ${lib.optionalString withTTS "--add-flags \"--enable-speech-dispatcher\""} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "vesktop";
      desktopName = "Vesktop";
      exec = "vesktop %U";
      icon = "vesktop";
      startupWMClass = "Vesktop";
      genericName = "Internet Messenger";
      keywords = [
        "discord"
        "vencord"
        "electron"
        "chat"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];

  passthru = {
    inherit (final) pnpmDeps;
  };

  meta = with lib; {
    description = "An alternate client for Discord with Vencord built-in";
    homepage = "https://github.com/Vencord/Vesktop";
    changelog = "https://github.com/Vencord/Vesktop/releases/tag/${final.src.rev}";
    license = licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "vesktop";
  };
})
