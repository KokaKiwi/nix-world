{ lib, stdenv

, fetchFromGitHub

, pkg-config
, autoreconfHook

, boost
, libmpdclient
, ncurses
, readline
, libiconv
, icu
, curl

, outputsSupport ? true # outputs screen
, visualizerSupport ? false, fftw # visualizer screen
, clockSupport ? true # clock screen
, taglibSupport ? true, taglib # tag editor
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ncmpcpp";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ncmpcpp";
    repo = "ncmpcpp";
    rev = finalAttrs.version;
    hash = "sha256-w3deSy71SWWD2kZKREowZh3KMNCBfBJbrjM0vW4/GrI=";
  };

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [ pkg-config autoreconfHook ]
    ++ lib.optional taglibSupport taglib;

  buildInputs = [ boost libmpdclient ncurses readline libiconv icu curl ]
    ++ lib.optional visualizerSupport fftw
    ++ lib.optional taglibSupport taglib;

  configureFlags = [
    "BOOST_LIB_SUFFIX="
    (lib.enableFeature outputsSupport "outputs")
    (lib.enableFeature visualizerSupport "visualizer")
    (lib.withFeature visualizerSupport "fftw")
    (lib.enableFeature clockSupport "clock")
    (lib.enableFeature taglibSupport "taglib")
  ];

  meta = with lib; {
    description = "Featureful ncurses based MPD client inspired by ncmpc";
    homepage    = "https://rybczak.net/ncmpcpp/";
    changelog   = "https://github.com/ncmpcpp/ncmpcpp/blob/${finalAttrs.version}/CHANGELOG.md";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral lovek323 ];
    platforms   = platforms.all;
    mainProgram = "ncmpcpp";
  };
})
