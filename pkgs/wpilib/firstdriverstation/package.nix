{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  udevCheckHook,
  makeBinaryWrapper,

  alsa-lib,
  angle,
  avahi,
  fontconfig,
  gtk3,
  icu,
  libGL,
  libgcc,
  libice,
  libinput,
  libpulseaudio,
  libsm,
  libusb1,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  pipewire,
  sndio,
  udev,
  webkitgtk_4_1,
  dhcpcd,
}:
let
  pname = "firstdriverstation";
  version = "2027.0.0-alpha-2";

  sourceURL = "https://github.com/wpilibsuite/FirstDriverStation-Public/releases/download/v${version}";
  sources = {
    "x86_64-linux" = fetchurl {
      url = "${sourceURL}/FirstDriverStation-linux-x64-${version}.tar.gz";
      hash = "sha256-MnDV6FQSYoPa3jQrXu+aD6UeNB9ZO4MtCHOqHTn5ei8=";
    };
    "aarch64-linux" = fetchurl {
      url = "${sourceURL}/FirstDriverStation-linux-arm64-${version}.tar.gz";
      hash = "sha256-CZ5VAlCIyz0mA+IjpbqRSjdSoozomCfhs46txbKhdag=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    udevCheckHook
  ];

  buildInputs = [
    makeBinaryWrapper

    alsa-lib
    angle
    avahi
    fontconfig
    libGL
    libgcc
    libinput
    libpulseaudio
    libusb1
    libx11
    libxcb
    libxcursor
    libxext
    libxfixes
    libxi
    libxrandr
    pipewire
    pipewire.jack
    sndio
    udev
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libGLES_CM.so.1"
    "libsteam_api.so"
  ];

  runtimeDependencies = [
    gtk3
    icu
    libice
    libsm
    libx11
    webkitgtk_4_1
  ];

  dontBuild = true;

  installPhase =
    let
      installPath = "$out/lib/wpilib/firstdriverstation";
    in
    ''
      runHook preInstall

      install -Dm744 ./FirstDriverStation ${installPath}/FirstDriverStation
      install -Dm744 ./libHarfBuzzSharp.so ${installPath}/libHarfBuzzSharp.so
      install -Dm744 ./libSkiaSharp.so ${installPath}/libSkiaSharp.so

      install -Dm644 ./License.txt $out/share/doc/FirstDriverStation/License.txt
      install -Dm644 ${./72-hidraw.rules} $out/etc/udev/rules.d/72-hidraw.rules

      makeBinaryWrapper ${installPath}/FirstDriverStation $out/bin/FirstDriverStation \
        --prefix PATH : ${lib.makeBinPath [ dhcpcd ]}

      runHook postInstall
    '';

  meta = {
    description = "Enables users to control their FTC and FRC robots.";
    homepage = "https://github.com/wpilibsuite/FirstDriverStation-Public/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ nullcube ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      # TODO: Support darwin
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];
    mainProgram = "FirstDriverStation";
  };
})
