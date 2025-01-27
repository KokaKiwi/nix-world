{ lib, stdenv

, fetchFromGitHub

, cmake
, python3
, pkg-config

, zlib
, libssh2
, openssl
, pcre2
, http-parser

, staticBuild ? stdenv.hostPlatform.isStatic
}:
stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.8.1";

  outputs = ["lib" "dev" "out"];

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    hash = "sha256-J2rCxTecyLbbDdsyBWn9w7r3pbKRMkI9E7RvRgAqBdY=";
  };

  cmakeFlags = with lib.strings; [
    (cmakeFeature "USE_HTTP_PARSER" "system")
    (cmakeFeature "REGEX_BACKEND" "pcre2")
    (cmakeBool "USE_SSH" true)
    (cmakeBool "BUILD_SHARED_LIBS" (!staticBuild))
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre2 http-parser ];

  doCheck = true;
  checkPhase = ''
    testArgs=(-v -xonline)

    # slow
    testArgs+=(-xclone::nonetwork::bad_urls)

    # failed to set permissions on ...: Operation not permitted
    testArgs+=(-xrepo::init::extended_1)
    testArgs+=(-xrepo::template::extended_with_template_and_shared_mode)

    (
      set -x
      ./libgit2_tests ''${testArgs[@]}
    )
  '';

  meta = with lib; {
    description = "Linkable library implementation of Git that you can use in your application";
    mainProgram = "git2";
    homepage = "https://libgit2.org/";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
