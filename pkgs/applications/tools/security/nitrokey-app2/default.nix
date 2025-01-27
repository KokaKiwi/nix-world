{ lib, stdenv

, fetchFromGitHub

, python3
, wrapQtAppsHook

, qtbase
, qtwayland
, qtsvg
}:
let
  poetry-core = python3.pkgs.poetry-core.overridePythonAttrs (super: rec {
    version = "1.9.1";

    src = fetchFromGitHub {
      owner = "python-poetry";
      repo = "poetry-core";
      tag = version;
      hash = "sha256-L8lR9sUdRYqjkDCQ0XHXZm5X6xD40t1gxlGiovvb/+8=";
    };
  });

  nitrokey = python3.pkgs.nitrokey.overridePythonAttrs (super: {
    build-system = [ poetry-core ];
  });
in python3.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.3.3";
  pyproject = true;

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "refs/tags/v${version}";
    hash = "sha256-BbgP4V0cIctY/oR4/1r1MprkIn+5oyHeFiOQQQ71mNU=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];
  build-system = [
    poetry-core
  ];

  buildInputs = [ qtbase ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland qtsvg
  ];

  dependencies = with python3.pkgs; [
    nitrokey
    pyside6
    qt-material
    usb-monitor
  ];

  pythonRelaxDeps = [ "pynitrokey" ];

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  postInstall = ''
    install -Dm755 meta/com.nitrokey.nitrokey-app2.desktop $out/share/applications/com.nitrokey.nitrokey-app2.desktop
    install -Dm755 meta/nk-app2.png $out/share/icons/hicolor/128x128/apps/com.nitrokey.nitrokey-app2.png
  '';

  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle panicgh ];
    mainProgram = "nitrokeyapp";
  };
}
