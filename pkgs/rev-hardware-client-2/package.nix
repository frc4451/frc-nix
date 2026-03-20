{
  lib,
  buildFHSEnv,
  stdenv,
  fetchurl,

  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  glib,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libgcc,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxshmfence,
  libxtst,
  libxxf86vm,
  nspr,
  nss,
  pango,
  systemdLibs,
  udev,
  wrapGAppsHook3,
}:
let
  pname = "rev-hardware-client-2";
  version = "1.0.7";

  rhc2-unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-unwrapped";
    inherit version;
    src = fetchurl {
      url = "https://rhc2.revrobotics.com/download/rev-hardware-client-1.0.7-linux-amd64.tar.gz";
      hash = "sha256-dIn32bBVarRVoHSG0cZiIt5W33Q5YuQToaZvN/Q8p7s=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      wrapGAppsHook3
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
      systemdLibs
      udev
    ];

    runtimeDependencies = [
      fontconfig
      libGL
      udev
      stdenv.cc.cc
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      cp -r . $out/
      substituteInPlace $out/share/applications/com.revrobotics.revui.rev-hardware-client.desktop \
      --replace-fail Exec=/usr/lib/rev-robotics/rev-hardware-client/bin/rev-hardware-client Exec=rev-hardware-client

      runHook postInstall
    '';
  });
in
buildFHSEnv {
  inherit pname version;

  targetPkgs = _: [
    rhc2-unwrapped

    fontconfig
    libGL
    udev
  ];

  runScript = "rev-hardware-client";

  extraInstallCommands = ''
    mkdir -p $out/
    cp -r ${rhc2-unwrapped}/share $out/share
  '';

  meta = {
    description = "Hardware client for REV devices.";
    homepage = "https://docs.revrobotics.com/rev-hardware-client-2";
    # license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ nullcube ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
