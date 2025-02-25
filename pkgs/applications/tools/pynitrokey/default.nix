{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  libnitrokey,
}:
python3Packages.buildPythonPackage rec {
  pname = "pynitrokey";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "pynitrokey";
    tag = "v${version}";
    hash = "sha256-Tfd/Ir/21xTPdcXJkbINU33NPSwONIlhutS7LdNqnGM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3Packages; [
    flit-core
  ];

  dependencies = with python3Packages; [
    certifi
    cffi
    click
    cryptography
    ecdsa
    fido2
    intelhex
    nkdfu
    python-dateutil
    pyusb
    requests
    tqdm
    tlv8
    typing-extensions
    click-aliases
    semver
    nethsm
    importlib-metadata
    nitrokey
    pyscard
    asn1crypto
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
