{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "minio-client";
  version = "2025-02-15T10-36-16Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-j4OT/3uxdvbRFjk6mKfenvezuEp7SRCBaL4Op53+IJc=";
  };

  vendorHash = "sha256-LffHP4HpcEzXDcbA15yrxHrLnO5YWtAICs4IBvOHwno=";

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mc --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/minio/mc";
    description = "Replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ bachp ];
    mainProgram = "mc";
    license = licenses.asl20;
  };
}
