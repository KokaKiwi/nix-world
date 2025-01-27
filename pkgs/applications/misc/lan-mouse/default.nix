{ lib

, fetchFromGitHub

, rustPlatform
, pkg-config
, wrapGAppsHook4

, features ? [ "wayland" "x11" "xdg_desktop_portal" "libei" "gtk" ]
, glib
, gtk4
, libadwaita
, xorg
}:
let
  hasFeature = lib.flip builtins.elem features;
in rustPlatform.buildRustPackage rec {
  pname = "lan-mouse";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "feschber";
    repo = "lan-mouse";
    rev = "v${version}";
    hash = "sha256-s80oaUDuFnbCluImLLliv1b1RDpIKrBWdX4hHy3xUIU=";
  };

  cargoHash = "sha256-rmiirWNS5Eldq0NyOyYielTPDdKbhtRqRS7RnGZ7H3g=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (hasFeature "gtk") [
      glib
      wrapGAppsHook4
    ];

  buildInputs =
    lib.optionals (hasFeature "x11") (with xorg; [
      libX11
      libXtst
    ])
    ++ lib.optionals (hasFeature "gtk") [
      glib
      gtk4
      libadwaita
    ];

  buildNoDefaultFeatures = true;

  buildFeatures = features;

  meta = {
    description = "A software KVM switch for sharing a mouse and keyboard with multiple hosts through the network";
    homepage = "https://github.com/feschber/lan-mouse";
    changelog = "https://github.com/feschber/lan-mouse/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "lan-mouse";
    maintainers = with lib.maintainers; [ pedrohlc ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
