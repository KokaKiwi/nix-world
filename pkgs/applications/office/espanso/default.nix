{ lib

, fetchFromGitHub

, rustPlatform

, extra-cmake-modules
, pkg-config
, makeWrapper
, wxGTK32

, bzip2
, dbus
, libnotify
, libxkbcommon
, openssl

, x11Support ? true, xorg
, xclip
, xdotool

, waylandSupport ? false, wayland
, wl-clipboard
}:
# espanso does not support building with both X11 and Wayland support at the same time
assert x11Support != waylandSupport;
rustPlatform.buildRustPackage {
  pname = "espanso";
  version = "2.2.1-unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "espanso";
    rev = "6b380d1edd94dff6505d97039ccb59c00ae1c5f4";
    hash = "sha256-CeY1fRKXkbPhFIddCXQMVGOm3RgfVi40w9+/dhCpc6g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "yaml-rust-0.4.6" = "sha256-wXFy0/s4y6wB3UO19jsLwBdzMy7CGX4JoUt5V6cU7LU=";
    };
  };

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
    makeWrapper
    wxGTK32
  ];

  buildInputs = [
    bzip2
    dbus
    libnotify
    libxkbcommon
    openssl
  ]
  ++ lib.optionals x11Support (with xorg; [
    libXi
    libXtst
    libX11
    xclip
    xdotool
  ])
  ++ lib.optionals waylandSupport [
    wayland
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "modulo" "native-tls" ]
    ++ lib.optionals waylandSupport [ "wayland" ];

  postInstall = let
    runtimeDeps = [
      libnotify
      xorg.setxkbmap
    ]
    ++ lib.optionals x11Support [
      xclip
    ]
    ++ lib.optionals waylandSupport [
      wl-clipboard
    ];
  in ''
  wrapProgram $out/bin/espanso \
    --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    mainProgram = "espanso";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
