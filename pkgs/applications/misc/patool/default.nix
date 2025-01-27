{ lib

, fetchFromGitHub

, python3Packages

, bzip2
, cabextract
, gnutar
, gzip
, lzip
, p7zip
, unar
, xz
, zip
, zpaq
, zstd
}: let
  compression-utilities = [
    bzip2
    cabextract
    gnutar
    gzip
    lzip
    p7zip
    unar
    xz
    zip
    zpaq
    zstd
  ];
in python3Packages.buildPythonPackage rec {
  pname = "patool";
  version = "3.1.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wummel";
    repo = "patool";
    rev = "refs/tags/${version}";
    hash = "sha256-mt/GUIRJHB2/Rritc+uNkolZzguYy2G/NKnSKNxKsLk=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ] ++ compression-utilities;

  disabledTests = [
    "test_7z"
    "test_7z_file"
    "test_7za_file"
    "test_p7azip"
    "test_unzip"
    "test_unzip_file"
    "test_zip"
    "test_zip_file"
  ];

  postInstall = ''
    wrapProgram $out/bin/patool \
      --suffix PATH : "${lib.makeBinPath compression-utilities}"
  '';

  meta = with lib; {
    description = "portable archive file manager";
    mainProgram = "patool";
    homepage = "https://wummel.github.io/patool/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
