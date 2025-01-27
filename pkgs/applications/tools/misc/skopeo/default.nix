{ lib, stdenv

, fetchFromGitHub

, buildGoModule
, runCommand
, installShellFiles
, makeWrapper

, gpgme
, lvm2
, btrfs-progs
, pkg-config
, go-md2man
, fuse-overlayfs
}:

buildGoModule rec {
  pname = "skopeo";
  version = "1.17.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    hash = "sha256-IoYeCGiGOjz+8HPzYPXUWsHADtrWHvJm9YhKeMJJf0k=";
  };

  outputs = [ "out" "man" ];

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
    ++ lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/skopeo completions docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=${placeholder "out"} make install-binary install-completions install-docs
    install ${passthru.policy}/default-policy.json -Dt $out/etc/containers
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
  '' + ''
    runHook postInstall
  '';

  passthru = {
    policy = runCommand "policy" { } ''
      install ${src}/default-policy.json -Dt $out
    '';
  };

  meta = with lib; {
    changelog = "https://github.com/containers/skopeo/releases/tag/${src.rev}";
    description = "A command line utility for various operations on container images and image repositories";
    mainProgram = "skopeo";
    homepage = "https://github.com/containers/skopeo";
    license = licenses.asl20;
  };
}
