{ lib

, fetchPypi
, fetchFromGitHub

, python3
, installShellFiles

, libnitrokey
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
in python3.pkgs.buildPythonPackage rec {
  pname = "pynitrokey";
  version = "0.7.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+sza4ZOJbElIdQLZFpoW0zs6KUYapRiC3gTxcj6Oqsg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3.pkgs; [
    flit-core
  ];

  dependencies = with python3.pkgs; [
    asn1crypto
    certifi
    cffi
    click
    click-aliases
    cryptography
    ecdsa
    fido2
    importlib-metadata
    intelhex
    nethsm
    nitrokey
    nkdfu
    pyscard
    python-dateutil
    pyusb
    requests
    semver
    tlv8
    tqdm
    typing-extensions
  ];

  pythonRelaxDeps = true;

  # pythonRelaxDepsHook runs in postBuild so cannot be used
  pypaBuildFlags = [ "--skip-dependency-check" ];

  # libnitrokey is not propagated to users of the pynitrokey Python package.
  # It is only usable from the wrapped bin/nitropy
  makeWrapperArgs = [ "--set LIBNK_PATH ${lib.makeLibraryPath [ libnitrokey ]}" ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynitrokey" ];

  postInstall = ''
    installShellCompletion --cmd nitropy \
      --bash <(_NITROPY_COMPLETE=bash_source $out/bin/nitropy) \
      --zsh <(_NITROPY_COMPLETE=zsh_source $out/bin/nitropy) \
      --fish <(_NITROPY_COMPLETE=fish_source $out/bin/nitropy)
  '';

  meta = with lib; {
    description = "Python client for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/pynitrokey";
    changelog = "https://github.com/Nitrokey/pynitrokey/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      frogamic
      raitobezarius
    ];
    mainProgram = "nitropy";
  };
}
