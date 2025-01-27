{ lib, stdenv

, fetchFromGitHub

, chafa
, cmake
, dbus
, dconf
, ddcutil
, glib
, hwdata
, imagemagick_light
, libdrm
, libglvnd
, libpulseaudio
, libselinux
, libsepol
, makeBinaryWrapper
, networkmanager
, ocl-icd
, opencl-headers
, pcre
, pcre2
, pkg-config
, python3
, rpm
, sqlite
, util-linux
, vulkan-loader
, wayland
, xfce
, xorg
, yyjson
, zlib

, rpmSupport ? false
, vulkanSupport ? true
, waylandSupport ? true
, x11Support ? true
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-ncaBMSV7n4RVA2376ExBv+a8bzuvuMttv3GlNaOH23k=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    chafa
    imagemagick_light
    pcre
    pcre2
    sqlite
    yyjson
    dbus
    dconf
    ddcutil
    glib
    hwdata
    libdrm
    libpulseaudio
    libselinux
    libsepol
    networkmanager
    ocl-icd
    opencl-headers
    util-linux
    zlib
  ] ++ lib.optionals rpmSupport [
    rpm
  ] ++ lib.optionals vulkanSupport [
    vulkan-loader
  ] ++ lib.optionals waylandSupport [
    wayland
  ] ++ lib.optionals x11Support [
    libglvnd
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
    xorg.libXrandr
    xorg.libxcb
    xfce.xfconf
  ];

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
    (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
    (lib.cmakeBool "ENABLE_DRM" false)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
    (lib.cmakeBool "ENABLE_OSMESA" false)
    (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)
    (lib.cmakeBool "ENABLE_GLX" x11Support)
    (lib.cmakeBool "ENABLE_RPM" rpmSupport)
    (lib.cmakeBool "ENABLE_VULKAN" x11Support)
    (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
    (lib.cmakeBool "ENABLE_X11" x11Support)
    (lib.cmakeBool "ENABLE_XCB" x11Support)
    (lib.cmakeBool "ENABLE_XCB_RANDR" x11Support)
    (lib.cmakeBool "ENABLE_XFCONF" x11Support)
    (lib.cmakeBool "ENABLE_XRANDR" x11Support)
    (lib.cmakeOptionType "filepath" "CUSTOM_PCI_IDS_PATH" "${hwdata}/share/hwdata/pci.ids")
    (lib.cmakeOptionType "filepath" "CUSTOM_AMDGPU_IDS_PATH" "${libdrm}/share/libdrm/amdgpu.ids")
  ];

  postPatch = ''
    substituteInPlace completions/fastfetch.fish --replace-fail python3 '${python3.interpreter}'
  '';

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    wrapProgram $out/bin/flashfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  meta = {
    description = "Like neofetch, but much faster because written in C";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
  };
})
