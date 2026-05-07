{
  lib,
  stdenv,
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  makeDesktopItem,
  udevCheckHook,
  makeBinaryWrapper,

  alsa-lib,
  angle,
  avahi,
  dhcpcd,
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
  openssl_legacy,
  pipewire,
  sndio,
  udev,
  webkitgtk_4_1,
}:
let
  pname = "firstdriverstation";
  version = "2027.0.0-alpha-3";

  sourceURL = "https://github.com/wpilibsuite/FirstDriverStation-Public/releases/download/v${version}";
  sources = {
    "x86_64-linux" = fetchurl {
      url = "${sourceURL}/FirstDriverStation-linux-x64-${version}.tar.gz";
      hash = "sha256-FiiE/YN1UImjh5DbOw/RH3lhoVZjU+HfTHw5zy9CgQQ=";
    };
    "aarch64-linux" = fetchurl {
      url = "${sourceURL}/FirstDriverStation-linux-arm64-${version}.tar.gz";
      hash = "sha256-4nVYcrjjMRuz0GhjSi+6mRGG3ytmxQBxynUUtFCRCp4=";
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
    copyDesktopItems
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
      install -Dm644 ${../wpilib_logo.svg} $out/share/icons/hicolor/scalable/apps/FirstDriverStation.svg

      makeBinaryWrapper ${installPath}/FirstDriverStation $out/bin/FirstDriverStation \
        --prefix PATH : ${lib.makeBinPath [ dhcpcd ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl_legacy ]}

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "FirstDriverStation";
      desktopName = name;
      exec = name;
      comment = finalAttrs.meta.description or null;
      icon = name;
      categories = [
        "Robotics"
        "Development"
      ];
      keywords = [
        "FRC"
        "FTC"
        "DriverStation"
      ];
    })
  ];
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
