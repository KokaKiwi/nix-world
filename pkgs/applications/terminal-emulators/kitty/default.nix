{ lib, stdenv, darwin

, fetchFromGitHub

, python3Packages

, buildGoModule
, installShellFiles

, ncurses
, pkg-config
, go
, fontconfig
, nerd-fonts ? null, nerdfonts
, imagemagick
, libicns
, wayland-scanner

, harfbuzz
, simde
, lcms2
, librsync
, openssl
, xxHash
, libpng
, zlib
, libunistring
, libcanberra
, libxkbcommon
, wayland, wayland-protocols
, dbus
, libGL
, xorg

, bashInteractive
, zsh
, fish
, sudo

, libstartup_notification

, nix-update-script
}:
let
  inherit (python3Packages) python;

  nerd-symbols = if nerd-fonts != null
    then nerd-fonts.symbols-only
    else nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; };
in python3Packages.buildPythonApplication rec {
  pname = "kitty";
  version = "0.39.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "refs/tags/v${version}";
    hash = "sha256-Cgbs9tdEGKhDShNh3M8N1UdRJu4aMylr9xLOGLpDAZE=";
  };

  goModules = (buildGoModule {
    pname = "kitty-go-modules";
    inherit src version;
    vendorHash = "sha256-j5ToLPQeaf4xIaziBAROYZNvoaOx2TkTcuY95X4Neqc=";
  }).goModules;

  patches = [
    # Gets `test_ssh_env_vars` to pass when `bzip2` is in the output of `env`.
    ./fix-test_ssh_env_vars.patch

    # Needed on darwin

    # Gets `test_ssh_shell_integration` to pass for `zsh` when `compinit` complains about
    # permissions.
    ./zsh-compinit.patch

    # Skip `test_ssh_bootstrap_with_different_launchers` when launcher is `zsh` since it causes:
    # OSError: master_fd is in error condition
    ./disable-test_ssh_bootstrap_with_different_launchers.patch
  ];

  nativeBuildInputs = (with python3Packages; [
    installShellFiles

    ncurses
    pkg-config
    go
    fontconfig
    nerd-symbols

    sphinx
    furo
    sphinx-copybutton
    sphinxext-opengraph
    sphinx-inline-tabs
  ]) ++ lib.optionals stdenv.isDarwin [
    imagemagick
    libicns  # For the png2icns tool.
  ] ++ lib.optionals stdenv.isLinux [
    wayland-scanner
  ];

  depsBuildBuild = [ pkg-config ];

  buildInputs = [
    harfbuzz
    ncurses
    simde
    lcms2
    librsync
    openssl.dev
    xxHash
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
    Kernel
    UniformTypeIdentifiers
    UserNotifications
    libpng
    python
    zlib
  ]) ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) (with darwin.apple_sdk.frameworks; [
    Libsystem
  ]) ++ lib.optionals stdenv.isLinux (with xorg; [
    fontconfig libunistring libcanberra libxkbcommon
    wayland-protocols wayland dbus libGL
    libX11 libXcursor libXext libXi
    libXinerama libXrandr
  ]);

  outputs = [ "out" "terminfo" "shell_integration" "kitten" ];

  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];

  CGO_ENABLED = 0;
  GOFLAGS = "-trimpath";

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=off

    cp -r --reflink=auto $goModules vendor
  '';

  buildPhase = let
    commonOptions = ''
      --update-check-interval=0 \
      --shell-integration="enabled no-rc"
    '';
    darwinOptions = ''
      --disable-link-time-optimization \
      ${commonOptions}
    '';
  in ''
    runHook preBuild

    ${lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
      export MACOSX_DEPLOYMENT_TARGET=11
    ''}
    ${if stdenv.isDarwin then ''
      ${python.pythonOnBuildForHost.interpreter} setup.py build ${darwinOptions}
      make docs
      ${python.pythonOnBuildForHost.interpreter} setup.py kitty.app ${darwinOptions}
    '' else ''
      ${python.pythonOnBuildForHost.interpreter} setup.py linux-package \
        --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
        --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
        --canberra-library='${libcanberra}/lib/libcanberra.so' \
        --fontconfig-library='${fontconfig.lib}/lib/libfontconfig.so' \
        ${commonOptions}
      ${python.pythonOnBuildForHost.interpreter} setup.py build-launcher
    ''}

    runHook postBuild
  '';

  nativeCheckInputs = [
    # Shells needed for shell integration tests
    bashInteractive
    zsh
    fish
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # integration tests need sudo
    sudo
  ] ++ (with python3Packages; [
    pillow
  ]);

  # skip failing tests due to darwin sandbox
  preCheck = lib.optionalString stdenv.isDarwin ''
    substituteInPlace kitty_tests/file_transmission.py \
      --replace test_file_get dont_test_file_get \
      --replace test_path_mapping_receive dont_test_path_mapping_receive \
      --replace test_transfer_send dont_test_transfer_send
    substituteInPlace kitty_tests/shell_integration.py \
      --replace test_fish_integration dont_test_fish_integration
    substituteInPlace kitty_tests/shell_integration.py \
      --replace test_bash_integration dont_test_bash_integration
    substituteInPlace kitty_tests/open_actions.py \
      --replace test_parsing_of_open_actions dont_test_parsing_of_open_actions
    substituteInPlace kitty_tests/ssh.py \
      --replace test_ssh_connection_data dont_test_ssh_connection_data
    substituteInPlace kitty_tests/fonts.py \
      --replace 'class Rendering(BaseTest)' 'class Rendering'
    # theme collection test starts an http server
    rm tools/themes/collection_test.go
    # passwd_test tries to exec /usr/bin/dscl
    rm tools/utils/passwd_test.go
  '';

  checkPhase = ''
    runHook preCheck

    # Fontconfig error: Cannot load default config file: No such file: (null)
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf

    # Required for `test_ssh_shell_integration` to pass.
    export TERM=kitty

    make test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    mkdir -p "$kitten/bin"
    ${if stdenv.isDarwin then ''
      mkdir "$out/bin"
      ln -s ../Applications/kitty.app/Contents/MacOS/kitty "$out/bin/kitty"
      ln -s ../Applications/kitty.app/Contents/MacOS/kitten "$out/bin/kitten"
      cp ./kitty.app/Contents/MacOS/kitten "$kitten/bin/kitten"
      mkdir "$out/Applications"
      cp -r kitty.app "$out/Applications/kitty.app"

      installManPage 'docs/_build/man/kitty.1'
    '' else ''
      cp -r linux-package/{bin,share,lib} "$out"
      cp linux-package/bin/kitten "$kitten/bin/kitten"
    ''}

    # dereference the `kitty` symlink to make sure the actual executable
    # is wrapped on macOS as well (and not just the symlink)
    wrapProgram $(realpath "$out/bin/kitty") --prefix PATH : "$out/bin:${lib.makeBinPath [ imagemagick ncurses.dev ]}"

    installShellCompletion --cmd kitty \
      --bash <("$out/bin/kitty" +complete setup bash) \
      --fish <("$out/bin/kitty" +complete setup fish2) \
      --zsh  <("$out/bin/kitty" +complete setup zsh)

    terminfo_src=${if stdenv.isDarwin then
      ''"$out/Applications/kitty.app/Contents/Resources/terminfo"''
      else
      "$out/share/terminfo"}

    mkdir -p $terminfo/share
    mv "$terminfo_src" $terminfo/share/terminfo

    mkdir -p "$out/nix-support"
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    cp -r 'shell-integration' "$shell_integration"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "Modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3Only;
    changelog = [
      "https://sw.kovidgoyal.net/kitty/changelog/"
      "https://github.com/kovidgoyal/kitty/blob/v${version}/docs/changelog.rst"
    ];
    platforms = platforms.darwin ++ platforms.linux;
    mainProgram = "kitty";
    maintainers = with maintainers; [ tex rvolosatovs Luflosi kashw2 ];
  };
}
