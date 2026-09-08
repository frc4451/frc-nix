{
  lib,
  flutter341,
  fetchFromGitHub,
  copyDesktopItems,
  stdenv,
  xz,
  libuuid,
  makeDesktopItem,
}:
# pinned: pathplanner's pubspec.lock holds meta 1.16.0, and flutter >= 3.47
# uses @awaitNotRequired from meta 1.17
flutter341.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2026.1.2";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ocqBviTfMxjdJdEu++yqUY9JTLs1qEnP94w6HCFp5f0=";
  };

  autoPubspecLock = src + "/pubspec.lock";

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    xz
  ]
  # provides libblkid on Linux
  ++ lib.optionals stdenv.isLinux [ libuuid ];

  postUnpack = ''
    # Make the version shown in the GUI match the actual version instead of "0.0.0"
    substituteInPlace source/pubspec.yaml \
      --replace-fail "version: 0.0.0+1" "version: ${version}"
  '';

  postInstall = ''
    install -Dm444 "${src}"/images/icon.png "$out"/share/pixmaps/${pname}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "PathPlanner";
      name = pname;
      exec = pname;
      icon = pname;
      comment = meta.description;
      categories = [ "Development" ];
      keywords = [
        "FRC"
        "Motion Profile"
        "Path Planning"
      ];
    })
  ];

  meta = with lib; {
    mainProgram = pname;
    description = "A simple yet powerful motion profile generator for FRC robots";
    homepage = "https://pathplanner.dev";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
