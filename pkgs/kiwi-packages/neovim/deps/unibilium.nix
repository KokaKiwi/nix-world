{ lib, stdenv

, fetchFromGitHub

, cmake

, ncurses
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unibilium";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "unibilium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6bFZtR8TUZJembRBj6wUUCyurUdsn3vDGnCzCti/ESc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ncurses
  ];

  meta = with lib; {
    description = "A terminfo library";
    homepage = "https://github.com/neovim/unibilium";
    changelog = "https://github.com/neovim/unibilium/blob/${finalAttrs.src.rev}/Changes";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
})
