{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writeTextFile,
  pkg-config,
  openssl,
  libgit2,
  libssh2,
  zlib,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.55";

  src = fetchFromGitHub {
    owner = "est31";
    repo = "cargo-udeps";
    tag = "v${version}";
    sha256 = "sha256-4/JfD2cH46it8PkU58buTHwFXBZI3sytyJCUWl+vSAE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4fF5nW8G2XMvC2K2nW7fhZL9DvjW4/cZXSCJurSu9NE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
    libssh2
    zlib
  ];

  preBuild = let
    # Force linking against libgit2
    libgit2_pkgconfig = writeTextFile rec {
      name = "libgit2.pc";
      destination = "/${name}";
      text = ''
        prefix="${libgit2}"
        libdir="${lib.getLib libgit2}/lib"
        includedir="${lib.getDev libgit2}/include"

        Name: libgit2
        Description: The git library, take 2
        Version: 1.8.2
        Libs: -L''${libdir} -lgit2
        Libs.private: -lllhttp -L${lib.getLib libssh2}/lib -lssh2 -lrt
        Requires.private: openssl libpcre2-8 zlib
        Cflags: -I''${includedir}
      '';
    };
  in ''
    export PKG_CONFIG_PATH="${libgit2_pkgconfig}:$PKG_CONFIG_PATH"
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
  };

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
    mainProgram = "cargo-udeps";
  };
}
