{ lib

, fetchFromGitHub

, python3

, atomicparsleySupport ? true, atomicparsley
, ffmpegSupport ? true, ffmpeg-headless
, rtmpSupport ? true, rtmpdump
, withAlias ? false # Provides bin/youtube-dl for backcompat
}:
python3.pkgs.buildPythonPackage rec {
  pname = "yt-dlp";
  version = "2025.01.26-unstable-2025-01-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "yt-dlp";
    rev = "03c3d705778c07739e0034b51490877cffdc0983";
    hash = "sha256-RxlfmNxGEq6AulLJUnGhFwBzuvPxcS8o3pO/Km1iVvM=";
  };

  # curl-cffi 0.7.2 and 0.7.3 are broken, but 0.7.4 is fixed
  # https://github.com/lexiforest/curl_cffi/issues/394
  postPatch = ''
    substituteInPlace yt_dlp/networking/_curlcffi.py \
      --replace-fail "(0, 7, 0) <= curl_cffi_version < (0, 7, 2)" \
        "((0, 7, 0) <= curl_cffi_version < (0, 7, 2)) or curl_cffi_version >= (0, 7, 4)"
  '';

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = lib.flatten (lib.attrValues optional-dependencies);

  optional-dependencies = with python3.pkgs; {
    default = [
      brotli
      certifi
      mutagen
      pycryptodomex
      requests
      urllib3
      websockets
    ];
    curl-cffi = [
      curl-cffi
    ];
    secretstorage = [
      cffi
      secretstorage
    ];
  };

  pythonRelaxDeps = [ "websockets" ];

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs =
    let
      packagesToBinPath = [ ]
        ++ lib.optional atomicparsleySupport atomicparsley
        ++ lib.optional ffmpegSupport ffmpeg-headless
        ++ lib.optional rtmpSupport rtmpdump;
    in lib.optionals (packagesToBinPath != []) [
      ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"''
    ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  # Requires network
  doCheck = false;

  postInstall = lib.optionalString withAlias ''
    ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
  '';

  meta = with lib; {
    homepage = "https://github.com/yt-dlp/yt-dlp/";
    description = "Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)";
    longDescription = ''
      yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    changelog = "https://github.com/yt-dlp/yt-dlp/blob/${version}/Changelog.md";
    license = licenses.unlicense;
    mainProgram = "yt-dlp";
  };
}
