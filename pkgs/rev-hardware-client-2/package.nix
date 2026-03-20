{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,

  wrapGAppsHook4,

  at-spi2-atk,
  cairo,
  glib,
  gtk3,
  pango,
  libx11,

  cups,
  libxrandr,
  libxdamage,
  libxcursor,
  libxtst,
  libgcc,
  libdrm,
  libgbm,
  nss,
  libxxf86vm,

  nspr,
  atk,
  expat,
  libxkbcommon,
  alsa-lib,
  dbus,
  at-spi2-core,
  libGL,
  udev,
  systemdLibs,
  libxfixes,
  libxext,
  libxcomposite,
  libxshmfence,
  libxcb,

  fontconfig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rev-hardware-client-2";
  version = "1.0.7";

  src = fetchurl {
    url = "https://rhc2.revrobotics.com/download/rev-hardware-client-1.0.7-linux-amd64.tar.gz";
    hash = "sha256-dIn32bBVarRVoHSG0cZiIt5W33Q5YuQToaZvN/Q8p7s=";
  };

  nativeBuildInputs = [
    # wrapGAppsHook3
    wrapGAppsHook4
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cairo
    cups
    cups.lib
    dbus
    expat
    glib
    gtk3
    libGL
    libdrm
    libgbm
    libgcc
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxshmfence
    libxtst
    libxxf86vm
    nspr
    nss
    pango
    stdenv.cc.cc
    systemdLibs
    udev
    fontconfig
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r . $out/

    runHook postInstall
  '';

  # preFixup = "";

  meta = {
    description = "Hardware client for REV devices.";
    homepage = "https://docs.revrobotics.com/rev-hardware-client-2";
    # license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ nullcube ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
})
