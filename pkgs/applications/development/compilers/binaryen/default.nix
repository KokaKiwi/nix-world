{ lib, stdenv

, fetchFromGitHub

, cmake
, python3
}:
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "122";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "refs/tags/version_${version}";
    hash = "sha256-CrgRg1oJMZ325zlitdZu26wb4GZfNWs1Z7cOlWSaqKI=";
  };

  nativeBuildInputs = [ cmake python3 ];

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/googletest/d' third_party/CMakeLists.txt
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa willcohen ];
    license = licenses.asl20;
  };
}
