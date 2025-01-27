{ lib, stdenv

, fetchFromGitHub

, pkg-config
, wayland-scanner

, xorg
, cairo
, wayland
, wayland-protocols
, libconfig

, backends ? [ "wayland" "x11" ]
, addons ? [ "libconfig" ]
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "activate-linux";
  version = "1.1.0-unstable-2024-10-03";

  src = fetchFromGitHub {
    owner = "MrGlockenspiel";
    repo = "activate-linux";
    rev = "75d00638d552c0b5983caf1c12fa8547e2580969";
    hash = "sha256-gbLwxgpzNJY8+cGfY3JJCNDB7ZzTweeV4js7j+3nEYE=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (lib.elem "wayland" backends) [
    wayland-scanner
  ];

  buildInputs = [
    cairo
  ]
  ++ lib.optionals (lib.elem "x11" backends) (with xorg; [
    libX11
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXt
    xorgproto
  ])
  ++ lib.optionals (lib.elem "wayland" backends) [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals (lib.elem "libconfig" addons) [
    libconfig
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    makeFlags+=(
      "backends=${lib.concatStringsSep " " backends}"
      "with=${lib.concatStringsSep " " addons}"
    )
  '';

  postInstall = ''
    install -Dm444 res/icon.png $out/share/icons/hicolor/128x128/apps/activate-linux.png
    install -Dm444 res/activate-linux.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/activate-linux.desktop \
      --replace 'Icon=icon' 'Icon=activate-linux'
  '';

  meta = with lib; {
    description = "\"Activate Windows\" watermark ported to Linux";
    homepage = "https://github.com/MrGlockenspiel/activate-linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "activate-linux";
  };
})
