{ lib, stdenv

, fetchFromGitHub

, buildGoModule

, pkg-config
, libsecret
}:
buildGoModule rec {
  pname = "docker-credential-helpers";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "docker";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LFXSfb4JnlacSZVnIf+5/A+KefARYadEGDzGtcSDJBw=";
  };

  vendorHash = null;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ libsecret ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker/docker-credential-helpers/credentials.Version=${version}"
  ];

  buildPhase =
    let
      cmds = if stdenv.isDarwin then [ "osxkeychain" "pass" ] else [ "secretservice" "pass" ];
    in
    ''
      for cmd in ${builtins.toString cmds}; do
        go build -ldflags "${builtins.toString ldflags}" -trimpath -o bin/docker-credential-$cmd ./$cmd/cmd
      done
    '';

  installPhase = ''
    install -Dm755 -t $out/bin bin/docker-credential-*
  '';

  meta = with lib; {
    description = "Suite of programs to use native stores to keep Docker credentials safe";
    homepage = "https://github.com/docker/docker-credential-helpers";
    license = licenses.mit;
  } // lib.optionalAttrs stdenv.isDarwin {
    mainProgram = "docker-credential-osxkeychain";
  };
}
