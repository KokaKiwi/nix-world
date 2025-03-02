{
  lib,
  stdenv,
  cmake,
  python3,
  fetchFromGitHub,
  emscripten,
  gtest,
  lit,
  nodejs,
  filecheck,
}:
let
  testsuite = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "testsuite";
    rev = "e05365077e13a1d86ffe77acfb1a835b7aa78422";
    hash = "sha256-yvZ5AZTPUA6nsD3xpFC0VLthiu2CxVto66RTXBXXeJM=";
  };
in
stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "122";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    tag = "version_${version}";
    hash = "sha256-5pNLkim1LjKn6Pa7V4d1x3TBY3fJIPjMY8VVB2tBbs0=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/googletest/d' third_party/CMakeLists.txt
      rmdir test/spec/testsuite
      ln -s ${testsuite} test/spec/testsuite
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  nativeCheckInputs = [
    gtest
    lit
    nodejs
    filecheck
  ];
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib python3 ../check.py $tests
  '';

  tests = [
    "version"
    "wasm-opt"
    "wasm-dis"
    "crash"
    "dylink"
    "ctor-eval"
    "wasm-metadce"
    "wasm-reduce"
    "spec"
    "lld"
    "wasm2js"
    "validator"
    "example"
    "unit"
    # "binaryenjs" "binaryenjs_wasm" # not building this
    "lit"
    "gtest"
  ];
  # doCheck = stdenv.isLinux;
  doCheck = false; # BROKEN

  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [
      asppsa
      willcohen
    ];
    license = licenses.asl20;
  };
  passthru.tests = {
    inherit emscripten;
  };
}
