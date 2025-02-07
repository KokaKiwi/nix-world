{
  libuv,
}:
final: prev:
let
  inherit (final) callPackage;
in {
  luv = callPackage ({
    buildLuarocksPackage,
    luaOlder,

    fetchurl,

    cmake,
  }: buildLuarocksPackage rec {
    pname = "luv";
    version = "1.50.0-1";

    knownRockspec = let
      spec = fetchurl {
        url = "mirror://luarocks/${pname}-${version}.rockspec";
        hash = "sha256-IL2EejtmT0pw0cAupMz0gvP3a19NPsc45W1RaoeGJgY=";
      };
    in spec.outPath;

    src = fetchurl {
      url = "https://github.com/luvit/luv/releases/download/${version}/luv-${version}.tar.gz";
      hash = "sha256-2GfDAk2cmB1U8u3YPhP9bcEVjwYIY197HA9rVYa1vDQ=";
    };

    disabled = luaOlder "5.1";

    nativeBuildInputs = [
      cmake
    ];

    meta = {
      homepage = "https://github.com/luvit/luv";
      description = "Bare libuv bindings for lua";
      license.fullName = "Apache 2.0";
    };
  }) { };

  libluv = callPackage ({
    stdenv,

    isLuaJIT,

    cmake,
    pkg-config,
  }: stdenv.mkDerivation {
    pname = "libluv";
    inherit (final.luv) version src;

    # to make sure we dont use bundled deps
    postUnpack = ''
      rm -rf deps/lua deps/libuv
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [
      final.lua
      libuv
    ];

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_MODULE=OFF"
      "-DWITH_SHARED_LIBUV=ON"
      "-DLUA_BUILD_TYPE=System"
      "-DWITH_LUA_ENGINE=${if isLuaJIT then "LuaJit" else "Lua"}"
    ];

    inherit (final.luv) meta;
  }) { };
}
