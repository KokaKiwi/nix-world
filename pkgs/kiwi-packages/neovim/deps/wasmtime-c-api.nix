{ lib, stdenv

, fetchFromGitHub

, cmake
, rustPlatform
, cargo, rustc
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmtime-c-api";
  version = "30.0.2";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Og3W8XXWWCpfk8zwZuQy2t9LULrE/0vgp5mzvXiTfBI=";
  };

  nativeBuildInputs = [
    cmake

    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-YupZr9jturuiFICubrXeOpAeFRvvdX4iRrarBkGL2s0=";
  };

  cmakeDir = "../crates/c-api";

  meta = with lib; {
    description =
      "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://wasmtime.dev/";
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${finalAttrs.version}/RELEASES.md";
    license = licenses.asl20;
    mainProgram = "wasmtime";
    platforms = platforms.unix;
  };
})
