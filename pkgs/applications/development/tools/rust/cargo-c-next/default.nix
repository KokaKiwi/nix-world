{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  curl,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-c";
  version = "0.10.11";

  src = fetchFromGitHub {
    owner = "lu-zero";
    repo = "cargo-c";
    tag = "v${version}";
    hash = "sha256-DvccPZzKSSZDt4APXWtYAcZptaRErmbZmqg0FVWrM/Y=";
  };

  cargoLock.lockFile = fetchurl {
    url = "https://github.com/lu-zero/cargo-c/releases/download/v${version}/Cargo.lock";
    hash = "sha256-xl7h/NL++go8VyR3JDxkMm8h/1yFuWCnl1ZjFBEh65E=";
  };

  postPatch = ''
    ln -s ${cargoLock.lockFile} ./Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config (lib.getDev curl) ];
  buildInputs = [ openssl curl ];

  # Ensure that we are avoiding build of the curl vendored in curl-sys
  doInstallCheck = stdenv.hostPlatform.libc == "glibc";
  installCheckPhase = ''
    runHook preInstallCheck

    ldd "$out/bin/cargo-cbuild" | grep libcurl.so

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Cargo subcommand to build and install C-ABI compatible dynamic and static libraries";
    longDescription = ''
      Cargo C-ABI helpers. A cargo applet that produces and installs a correct
      pkg-config file, a static library and a dynamic library, and a C header
      to be used by any C (and C-compatible) software.
    '';
    homepage = "https://github.com/lu-zero/cargo-c";
    changelog = "https://github.com/lu-zero/cargo-c/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cpu ];
  };
}
