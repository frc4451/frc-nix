{
  lib,
  frc-nix-maintainers,
  buildFHSEnv,
  stdenv,
  fetchurl,

  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
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
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxshmfence,
  libxtst,
  libxxf86vm,
  nspr,
  nss,
  pango,
  systemdLibs,
  udev,
  xdg-utils,
  zlib,
}:
let
  pname = "rev-hardware-client-2";
  version = "1.4.3";
  mainProgram = "rev-hardware-client";

  arch =
    {
      x86_64-linux = {
        name = "amd64";
        hash = "sha256-aeiwKI0O95J1rE9/uGEg7Jg8xO9Pd4fPdz/ITYITfOU=";
      };
      aarch64-linux = {
        name = "aarch64";
        hash = "sha256-2nFrPnKik5WKBM59oOIvsEAf+tIi1FeAqrE1RodaJf4=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  rhc2-unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-unwrapped";
    inherit version;
    src = fetchurl {
      url = "https://rhc2.revrobotics.com/download/rev-hardware-client-${version}-linux-${arch.name}.tar.gz";
      name = "${pname}-${version}-src-${arch.name}.tar.gz";
      inherit (arch) hash;
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      cp -r . $out/
      substituteInPlace $out/share/applications/com.revrobotics.revui.rev-hardware-client.desktop \
      --replace-fail 'Exec=/usr/lib/rev-robotics/rev-hardware-client/bin/${mainProgram}' 'Exec=${mainProgram}'

      runHook postInstall
    '';
  });
in
buildFHSEnv {
  inherit pname version;

  targetPkgs = _: [
    rhc2-unwrapped

    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
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
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxshmfence
    libxtst
    libxxf86vm
    nspr
    nss
    pango
    stdenv.cc.cc
    systemdLibs
    udev
    xdg-utils
    zlib
  ];

  extraInstallCommands = ''
    mkdir -p $out/
    cp -r ${rhc2-unwrapped}/share $out/share
  '';

  runScript = mainProgram;
  executableName = mainProgram;

  meta = {
    description = "Hardware client for REV devices";
    homepage = "https://docs.revrobotics.com/rev-hardware-client-2";
    downloadPage = "https://rhc2.revrobotics.com/download/download.html";
    changelog = "https://docs.revrobotics.com/rev-hardware-client-2/rhc2/overview/changelog";
    license = lib.licenses.unfree;
    maintainers = with frc-nix-maintainers; [ nullcube ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    inherit mainProgram;
  };
}
