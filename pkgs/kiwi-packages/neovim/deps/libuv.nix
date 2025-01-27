{ lib, stdenv

, fetchFromGitHub

, autoconf
, automake
, libtool
, pkg-config
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.50.0";
  pname = "libuv";

  src = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1Z/zf4qZYDM5upHdRtc1HGpHaGTRHm147azJZ0pT5pU=";
  };

  outputs = [ "out" "dev" ];

  postPatch = let
    toDisable = [
      "getnameinfo_basic" "udp_send_hang_loop" # probably network-dependent
      "tcp_connect_timeout" # tries to reach out to 8.8.8.8
      "spawn_setuid_fails" "spawn_setgid_fails" "fs_chown" # user namespaces
      "getaddrinfo_fail" "getaddrinfo_fail_sync" "tcp_connect6_link_local"
      "threadpool_multiple_event_loops" # times out on slow machines
      "get_passwd" # passed on NixOS but failed on other Linuxes
      "tcp_writealot" "udp_multicast_join" "udp_multicast_join6" "metrics_pool_events" # times out sometimes
      "fs_fstat" # https://github.com/libuv/libuv/issues/2235#issuecomment-1012086927

      # Assertion failed in test/test-tcp-bind6-error.c on line 60: r == UV_EADDRINUSE
      # Assertion failed in test/test-tcp-bind-error.c on line 99: r == UV_EADDRINUSE
      "tcp_bind6_error_addrinuse" "tcp_bind_error_addrinuse_listen"
      # https://github.com/libuv/libuv/pull/4075#issuecomment-1935572237
      "thread_priority"
    ];
    tdRegexp = lib.concatStringsSep "\\|" toDisable;
    in lib.optionalString (finalAttrs.finalPackage.doCheck) ''
      sed '/${tdRegexp}/d' -i test/test-list.h
    '';

  nativeBuildInputs = [ automake autoconf libtool pkg-config ];

  preConfigure = ''
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  enableParallelBuilding = true;

  # separateDebugInfo breaks static build
  # https://github.com/NixOS/nixpkgs/issues/219466
  separateDebugInfo = !stdenv.hostPlatform.isStatic;

  doCheck =
    # routinely hangs on powerpc64le
    !stdenv.hostPlatform.isPower64;

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Multi-platform support library with a focus on asynchronous I/O";
    homepage    = "https://libuv.org/";
    changelog   = "https://github.com/libuv/libuv/blob/v${finalAttrs.version}/ChangeLog";
    pkgConfigModules = [ "libuv" ];
    maintainers = [ ];
    platforms   = platforms.all;
    license     = with licenses; [ mit isc bsd2 bsd3 cc-by-40 ];
  };
})
