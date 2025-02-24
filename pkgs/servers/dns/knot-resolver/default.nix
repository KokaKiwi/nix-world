{
  lib,
  stdenv,
  fetchurl,
  # native deps.
  runCommand,
  pkg-config,
  meson,
  ninja,
  makeWrapper,
  # build+runtime deps.
  knot-dns,
  luajitPackages,
  libuv,
  gnutls,
  lmdb,
  jemalloc,
  systemd,
  libcap_ng,
  dns-root-data,
  nghttp2, # optionals, in principle
  fstrm,
  protobufc, # more optionals
  # test-only deps.
  cmocka,
  which,
  cacert,
  extraFeatures ? false, # catch-all if defaults aren't enough
}:
let # un-indented, over the whole file

  result = if extraFeatures then wrapped-full else unwrapped;

  inherit (lib) optional optionals optionalString;
  lua = luajitPackages;

  unwrapped = stdenv.mkDerivation rec {
    pname = "knot-resolver";
    version = "6.0.10";

    src = fetchurl {
      url = "https://secure.nic.cz/files/knot-resolver/${pname}-${version}.tar.xz";
      hash = "sha256-t8sLNnKDYRRYF0fMXt3kxludB/jWYooAvOsLVqFL45U=";
    };

    outputs = [
      "out"
      "dev"
    ];

    # Path fixups for the NixOS service.
    postPatch = ''
      patch meson.build <<EOF
      @@ -50,2 +50,2 @@
      -systemd_work_dir = prefix / get_option('localstatedir') / 'lib' / 'knot-resolver'
      -systemd_cache_dir = prefix / get_option('localstatedir') / 'cache' / 'knot-resolver'
      +systemd_work_dir  = '/var/lib/knot-resolver'
      +systemd_cache_dir = '/var/cache/knot-resolver'
      EOF

      # ExecStart can't be overwritten in overrides.
      # We need that to use wrapped executable and correct config file.
      sed '/^ExecStart=/d' -i systemd/kresd@.service.in
    ''
    # https://gitlab.nic.cz/knot/knot-resolver/-/issues/925
    + ''
      patch modules/http/meson.build <<EOF
      @@ -22 +21,0 @@
      -  ['http', files('http.test.lua')],
      EOF
    ''
    # some tests have issues with network sandboxing, apparently
    + optionalString doInstallCheck ''
      echo 'os.exit(77)' > daemon/lua/trust_anchors.test/bootstrap.test.lua
      sed -E '/^[[:blank:]]*test_(dstaddr|headers),?$/d' -i \
        tests/config/doh2.test.lua modules/http/http_doh.test.lua
    '';

    preConfigure = ''
      patchShebangs scripts/
    '';

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
    ];

    # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
    buildInputs =
      [
        knot-dns
        lua.lua
        libuv
        gnutls
        lmdb
      ]
      ## the rest are optional dependencies
      ++ optionals stdenv.hostPlatform.isLinux [
        # lib
        systemd
        libcap_ng
      ]
      ++ [
        jemalloc
        nghttp2
      ]
      ++ [
        fstrm
        protobufc
      ] # dnstap support
    ;

    mesonFlags = [
      "-Dkeyfile_default=${dns-root-data}/root.ds"
      "-Droot_hints=${dns-root-data}/root.hints"
      "-Dinstall_kresd_conf=disabled" # not really useful; examples are inside share/doc/
      "-Dmalloc=jemalloc"
      "--default-library=static" # not used by anyone
    ]
    ++ optional doInstallCheck "-Dunit_tests=enabled"
    ++ optional doInstallCheck "-Dconfig_tests=enabled"
    ++ optional stdenv.hostPlatform.isLinux "-Dsystemd_files=enabled" # used by NixOS service
    ;

    postInstall = ''
      rm "$out"/lib/libkres.a
      # rm "$out"/lib/knot-resolver/upgrade-5-to-6.lua # not meaningful on NixOS
    ''
    + optionalString stdenv.hostPlatform.isLinux ''
      rm -r "$out"/lib/sysusers.d/ # ATM more likely to harm than help
    '';

    doInstallCheck = with stdenv; hostPlatform == buildPlatform;
    nativeInstallCheckInputs = [
      cmocka
      which
      cacert
      lua.cqueues
      lua.basexx
      lua.http
    ];
    installCheckPhase = ''
      meson test --print-errorlogs --no-suite snowflake
    '';

    meta = with lib; {
      description = "Caching validating DNS resolver, from .cz domain registry";
      homepage = "https://knot-resolver.cz";
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
      maintainers = [
        maintainers.vcunat # upstream developer
      ];
      mainProgram = "kresd";
    };
  };

  wrapped-full =
    runCommand unwrapped.name {
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = with luajitPackages; [
        # For http module, prefill module, trust anchor bootstrap.
        # It brings lots of deps; some are useful elsewhere (e.g. cqueues).
        http
        # used by policy.slice_randomize_psl()
        psl
      ];
      preferLocalBuild = true;
      allowSubstitutes = false;
      inherit (unwrapped) meta;
    } (''
      mkdir -p "$out"/bin
      makeWrapper '${unwrapped}/bin/kresd' "$out"/bin/kresd \
        --set LUA_PATH  "$LUA_PATH" \
        --set LUA_CPATH "$LUA_CPATH"

      ln -sr '${unwrapped}/share' "$out"/
      ln -sr '${unwrapped}/lib'   "$out"/ # useful in NixOS service
      ln -sr "$out"/{bin,sbin}
    ''
    + lib.optionalString unwrapped.doInstallCheck ''
      echo "Checking that 'http' module loads, i.e. lua search paths work:"
      echo "modules.load('http')" > test-http.lua
      echo -e 'quit()' | env -i "$out"/bin/kresd -a 127.0.0.1#53535 -c test-http.lua
    '');

in
result
